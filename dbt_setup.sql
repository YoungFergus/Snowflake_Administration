USE ROLE SECURITYADMIN;

CREATE ROLE DBT_ROLE
    COMMENT = 'Role for DBT service user';


CREATE USER DBT_SVC
    PASSWORD = 'generate_password'
    LOGIN_NAME = DBT_SVC -- match the username above
    DISPLAY_NAME = 'DBT Service User' -- can be same as Login Name or more descriptive, purely for administrative purposes
    EMAIL = ''
    DEFAULT_WAREHOUSE = DEMO_WH -- change depending on team function
    DEFAULT_ROLE = DBT_ROLE; -- change depending on team function


GRANT ROLE DBT_ROLE TO USER DBT_SVC;

/* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~`
    #################################################
    ##### Instructions for Use of Following ACL #####
    #################################################

        WHEN TO USE:
            1. Use when the DBT_SVC_ACCOUNT needs to make models in a database where DBT *** hasn't been used before ***
            2. This script should be stored with the other ACL for the DBT_ROLE
        
        HOW TO USE:
            1. Choose the database name
            2. Use Ctrl+H to open the find/replace function in your IDE
            3. Make sure Case sensitivity & match whole word options are off
            4. Find the word "TEMPLATE" and replace with your database name

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

USE ROLE SECURITYADMIN;

GRANT USAGE ON DATABASE TEMPLATE TO ROLE DBT_ROLE;
GRANT ALL PRIVILEGES ON SCHEMA TEMPLATE.RAW TO ROLE DBT_ROLE;
GRANT ALL PRIVILEGES ON SCHEMA TEMPLATE.INTERMEDIATE TO ROLE DBT_ROLE;
GRANT ALL PRIVILEGES ON SCHEMA TEMPLATE.PRESENTATION TO ROLE DBT_ROLE;
GRANT SELECT ON ALL TABLES IN SCHEMA TEMPLATE.RAW TO ROLE DBT_ROLE;
GRANT SELECT ON ALL TABLES IN SCHEMA TEMPLATE.INTERMEDIATE TO ROLE DBT_ROLE;
GRANT SELECT ON ALL TABLES IN SCHEMA TEMPLATE.PRESENTATION TO ROLE DBT_ROLE;
GRANT SELECT ON FUTURE TABLES IN SCHEMA TEMPLATE.RAW TO ROLE DBT_ROLE;
GRANT SELECT ON FUTURE TABLES IN SCHEMA TEMPLATE.INTERMEDIATE TO ROLE DBT_ROLE;
GRANT SELECT ON FUTURE TABLES IN SCHEMA TEMPLATE.PRESENTATION TO ROLE DBT_ROLE;

--<in-dev>
USE WAREHOUSE GOVERNANCE_WH;
BEGIN
    DECLARE
        env_tag VARCHAR;
    BEGIN -- variable assignment
        SELECT current_Account() INTO env_tag;

    IF (env_tag = 'your_dev_env') THEN
        GRANT CREATE SCHEMA ON DATABASE TEMPLATE TO ROLE DBT_ROLE;
    END IF;
    END;
END;


-- ~~~~~~~~~~~~~~~~~~~~~~~ END TEMPLATE ~~~~~~~~~~~~~~~~~~~~~~~~~~
-- /note: Schema DBT_ERRORS is automatically created by DBT
USE ROLE SYSADMIN;
BEGIN
    CREATE OR REPLACE PROCEDURE GOVERNANCE.DBT_ERRORS.dbt_cloud_warnings_email()
        RETURNS INTEGER
        LANGUAGE SQL
        EXECUTE AS CALLER
    AS
    DECLARE
        body STRING;
    BEGIN

        body := (
            with warnings as (
                SELECT 'Warning on: ' || REPLACE(TABLE_NAME, 'WARNING_', '') as message
                FROM GOVERNANCE.INFORMATION_SCHEMA.TABLES
                WHERE TABLE_SCHEMA = 'DBT_ERRORS'
                    AND TABLE_NAME LIKE 'WARNING_%'
                    AND ROW_COUNT > 0
                    AND (CREATED >= DATEADD(DAY, -1, CURRENT_TIMESTAMP)
                        OR LAST_ALTERED >= DATEADD(DAY, -1, CURRENT_TIMESTAMP))
            )
            SELECT LISTAGG(message, '\n') as body FROM warnings
        );


        CALL SYSTEM$SEND_EMAIL(
            'alert_integration',
            'emails@here.com'
            'DBT Cloud Warnings: ' || CAST(CURRENT_DATE() as varchar),
            'Over the last 24 hours, the following DBT warnings were triggered: \n \n' || :body || '\n \nPlease consult DBT Cloud for further info'
        );

        RETURN 0;
    END;

CREATE ALERT GOVERNANCE.DBT_ERRORS.DBT_CLOUD_WARNINGS
    WAREHOUSE = GOVERNANCE_WH
    SCHEDULE = 'USING CRON 0 13 * * * UTC'
    COMMENT = 'Alert that checks daily if any warnings from DBT runs were triggered in the last 24 hours'
    IF( EXISTS(
        SELECT *
        FROM GOVERNANCE.INFORMATION_SCHEMA.TABLES
        WHERE TABLE_SCHEMA = 'DBT_ERRORS'
            AND TABLE_NAME LIKE 'WARNING_%'
            AND ROW_COUNT > 0
            AND (CREATED >= DATEADD(DAY, -1, CURRENT_TIMESTAMP)
                    OR LAST_ALTERED >= DATEADD(DAY, -1, CURRENT_TIMESTAMP))
        GROUP BY ALL
    ))
    THEN
        CALL GOVERNANCE.DBT_ERRORS.dbt_cloud_warnings_email();

END;

