CREATE ACCOUNT Account_Name
    ADMIN_NAME = 'SNOW_ADMIN'
    ADMIN_PASSWORD = ''
    FIRST_NAME = 'Snow'
    LAST_NAME = 'Admin'
    EMAIL = 'example@gmail.com'
    MUST_CHANGE_PASSWORD = FALSE
    EDITION = BUSINESS_CRITICAL -- depends on your snowflake subscription
    COMMENT = 'Add relevant information here';

-- Talk with Snowflake support about creating a naming convention that makes it easier to change env connection strings

GRANT ROLE SECURITYADMIN TO USER EFERGUSON;

USE ROLE SECURITYADMIN;

GRANT ROLE SYSADMIN TO USER SNOW_ADMIN;

USE ROLE SYSADMIN;

CREATE DATABASE IF NOT EXISTS GOVERNANCE
    DATA_RETENTION_TIME_IN_DAYS = 7
    COMMENT = 'Database that holds account wide governance objects';

CREATE SCHEMA IF NOT EXISTS GOVERNANCE.TAG_LIBRARY
    COMMENT = 'Schema to hold account wide tags for various objects';

CREATE SCHEMA IF NOT EXISTS GOVERNANCE.MONITORING
    COMMENT = 'Schema to hold alerts and resource monitors for the Snowflake account';


-- Create new system roles to assist workflows 
USE ROLE SECURITYADMIN;

---------------
-- Tag Admin --
---------------
CREATE ROLE IF NOT EXISTS TAG_ADMIN
    COMMENT = 'Role to create and manage snowflake tags';

USE ROLE ACCOUNTADMIN;
GRANT CREATE TAG ON SCHEMA GOVERNANCE.TAG_LIBRARY TO ROLE TAG_ADMIN;

USE ROLE SECURITYADMIN;
GRANT USAGE ON DATABASE GOVERNANCE TO ROLE TAG_ADMIN;
GRANT USAGE ON SCHEMA GOVERNANCE.TAG_LIBRARY TO ROLE TAG_ADMIN;

-- Connect Tag_Admin to SysAdmin
GRANT ROLE TAG_ADMIN TO ROLE SYSADMIN;

----------------
-- Task Admin --
----------------
CREATE ROLE IF NOT EXISTS TASK_ADMIN
    COMMENT = 'Role to manage Snowflake task workflows. Should be granted in conjunction with other roles.';

USE ROLE ACCOUNTADMIN;
GRANT EXECUTE TASK ON ACCOUNT TO ROLE TASK_ADMIN;
GRANT EXECUTE MANAGED TASK ON ACCOUNT TO ROLE TASK_ADMIN;
GRANT MONITOR EXECUTION ON ACCOUNT TO ROLE TASK_ADMIN;
GRANT DATABASE ROLE SNOWFLAKE.USAGE_VIEWER TO ROLE TASK_ADMIN;

-- Connect Task_Admin to SysAdmin
GRANT ROLE TASK_ADMIN TO ROLE SYSADMIN; -- sysadmin is responsible for creating tasks

-- write terraform hook which grants ownership of a task to the specific TASK_ADMIN role

/* 
    CREATE INITIAL WAREHOUSE

*/
USE ROLE SYSADMIN;
CREATE WAREHOUSE IF NOT EXISTS GOVERNANCE_WH
    WITH WAREHOUSE_TYPE = STANDARD
    WAREHOUSE_SIZE = XSMALL
    MAX_CLUSTER_COUNT = 2
    MIN_CLUSTER_COUNT = 1
    SCALING_POLICY = STANDARD
    AUTO_RESUME = TRUE
    INITIALLY_SUSPENDED = TRUE
    ENABLE_QUERY_ACCELERATION = FALSE
    COMMENT = 'Warehouse for account administration';

USE ROLE SECURITYADMIN;
GRANT MONITOR, USAGE, OPERATE ON WAREHOUSE DEMO_WH TO ROLE SECURITYADMIN;
