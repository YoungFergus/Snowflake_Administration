USE ROLE ACCOUNTADMIN;
CREATE NOTIFICATION INTEGRATION alert_integration
    TYPE = EMAIL
    ENABLED = TRUE;

USE ROLE SYSADMIN;
CREATE OR REPLACE ALERT.GOVERNANCE.MONITORING.ALERT_QUERY_OVER_HOUR
WAREHOUSE = GOVERNANCE_WH
SCHEDULE = '60 MINUTE'
COMMENT = 'Alert that checks and sees if any query is running longer than 60 minutes. Runs hourly'
IF( EXISTS(
    SELECT TIMESTAMPDIFF(SECOND, CURRENT_TIMESTAMP, start_time) AS elapsed_time_seconds
    FROM TABLE(SNOWFLAKE.INFORMATION_SCHEMA.QUERY_HISTORY())
    WHERE execution_status = 'RUNNING'
        AND elapsed_time_seconds > 3600
    )
)
THEN
    DECLARE
        body STRING;
    BEGIN
        body := (
            with alerts as (
                SELECT TIMESTAMPDIFF(SECOND, CURRENT_TIMESTAMP, start_time) AS elapsed_time_seconds,
                    'Query_Id: ' || query_id || ', User: ' || user_name || ', Role: ' || role_name || ', WH: ' || warehouse_name || ' - ' || IFNULL(warehouse_size,'') || ', total_time: ' || CAST(CAST(ABS(elapsed_time_seconds / 60) as int) as varchar) || ' minutes' as message
                FROM TABLE(SNOWFLAKE.INFORMATION_SCHEMA.QUERY_HISTORY())
                WHERE execution_status = 'RUNNING'
                    AND elapsed_time_seconds > 3600
            )
            SELECT LISTAGG(message, '\n') as body FROM alerts
        );

        CALL SYSTEM$SEND_EMAIL(
            'alert_integration',
            'example@gmail.com' -- add in administrator names here
            'Snowflake env - Long Running Queries: ' || CAST(CURRENT_TIMESTAMP as varchar),
            'Long running queries were detected in the Snowflake environment: \n \n' || :body '\n \nPlease consult the system for further info'
        );
    END;