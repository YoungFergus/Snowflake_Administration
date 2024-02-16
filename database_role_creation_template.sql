/*
    This file contains the standard declaration of access roles for a database in accordance with the 4 role scheme
    The template assumes you're creating a RAW, INTERMEDIATE, and PRESENTATION schema
*/

USE ROLE SECURITYADMIN;
CREATE OR REPLACE ROLE TEMPLATE_R
    COMMENT = 'Read only access for TEMPLATE database';

    -- DATABASE PERMISSIONS
GRANT USAGE, MONITOR ON DATABASE TEMPLATE TO ROLE TEMPLATE_R;

    -- Schemas
GRANT USAGE, MONITOR ON ALL SCHEMAS IN DATABASE TEMPLATE TO ROLE TEMPLATE_R;
GRANT USAGE, MONITOR ON FUTURE SCHEMAS IN DATABASE TEMPLATE TO ROLE TEMPLATE_R;

    -- Schema Objects
-- table
GRANT SELECT, REFERENCES ON ALL TABLES IN DATABASE TEMPLATE TO ROLE TEMPLATE_R;
GRANT SELECT, REFERENCES ON FUTURE TABLES IN SCHEMA TEMPLATE.RAW TO ROLE TEMPLATE_R;
GRANT SELECT, REFERENCES ON FUTURE TABLES IN SCHEMA TEMPLATE.INTERMEDIATE TO ROLE TEMPLATE_R;
GRANT SELECT, REFERENCES ON FUTURE TABLES IN SCHEMA TEMPLATE.PRESENTATION TO ROLE TEMPLATE_R;

-- view
GRANT SELECT, REFERENCES ON ALL VIEWS IN DATABASE TEMPLATE TO ROLE TEMPLATE_R;
GRANT SELECT, REFERENCES ON FUTURE VIEWS IN SCHEMA TEMPLATE.RAW TO ROLE TEMPLATE_R;
GRANT SELECT, REFERENCES ON FUTURE VIEWS IN SCHEMA TEMPLATE.INTERMEDIATE TO ROLE TEMPLATE_R;
GRANT SELECT, REFERENCES ON FUTURE VIEWS IN SCHEMA TEMPLATE.PRESENTATION TO ROLE TEMPLATE_R;

-- materialized view
GRANT SELECT, REFERENCES ON ALL MATERIALIZED VIEWS IN DATABASE TEMPLATE TO ROLE TEMPLATE_R;
GRANT SELECT, REFERENCES ON FUTURE MATERIALIZED VIEWS IN SCHEMA TEMPLATE.RAW TO ROLE TEMPLATE_R;
GRANT SELECT, REFERENCES ON FUTURE MATERIALIZED VIEWS IN SCHEMA TEMPLATE.INTERMEDIATE TO ROLE TEMPLATE_R;
GRANT SELECT, REFERENCES ON FUTURE MATERIALIZED VIEWS IN SCHEMA TEMPLATE.PRESENTATION TO ROLE TEMPLATE_R;

-- external table
GRANT SELECT, REFERENCES ON ALL EXTERNAL TABLES VIEWS IN DATABASE TEMPLATE TO ROLE TEMPLATE_R;
GRANT SELECT, REFERENCES ON FUTURE EXTERNAL TABLES IN SCHEMA TEMPLATE.RAW TO ROLE TEMPLATE_R;
GRANT SELECT, REFERENCES ON FUTURE EXTERNAL TABLES IN SCHEMA TEMPLATE.INTERMEDIATE TO ROLE TEMPLATE_R;
GRANT SELECT, REFERENCES ON FUTURE EXTERNAL TABLES IN SCHEMA TEMPLATE.PRESENTATION TO ROLE TEMPLATE_R;

-- sequence
GRANT ALL PRIVELEGES ON ALL SEQUENCES IN DATABASE TEMPLATE TO ROLE TEMPLATE_R;
GRANT ALL PRIVELEGES ON FUTURE SEQUENCES IN SCHEMA TEMPLATE.RAW TO ROLE TEMPLATE_R;
GRANT ALL PRIVELEGES ON FUTURE SEQUENCES IN SCHEMA TEMPLATE.INTERMEDIATE TO ROLE TEMPLATE_R;
GRANT ALL PRIVELEGES ON FUTURE SEQUENCES IN SCHEMA TEMPLATE.PRESENTATION TO ROLE TEMPLATE_R;

-- functions
GRANT USAGE ON ALL FUNCTIONS IN DATABASE TEMPLATE TO ROLE TEMPLATE_R;
GRANT USAGE ON FUTURE FUNCTIONS IN SCHEMA TEMPLATE.RAW TO ROLE TEMPLATE_R;
GRANT USAGE ON FUTURE FUNCTIONS IN SCHEMA TEMPLATE.INTERMEDIATE TO ROLE TEMPLATE_R;
GRANT USAGE ON FUTURE FUNCTIONS IN SCHEMA TEMPLATE.PRESENTATION TO ROLE TEMPLATE_R;

-- procedures
GRANT USAGE ON ALL PROCEDURES IN DATABASE TEMPLATE TO ROLE TEMPLATE_R;
GRANT USAGE ON FUTURE PROCEDURES IN SCHEMA TEMPLATE.RAW TO ROLE TEMPLATE_R;
GRANT USAGE ON FUTURE PROCEDURES IN SCHEMA TEMPLATE.INTERMEDIATE TO ROLE TEMPLATE_R;
GRANT USAGE ON FUTURE PROCEDURES IN SCHEMA TEMPLATE.PRESENTATION TO ROLE TEMPLATE_R;

-- file formats
GRANT USAGE ON ALL FILE FORMATS IN DATABASE TEMPLATE TO ROLE TEMPLATE_R;
GRANT USAGE ON FUTURE FILE FORMATS IN SCHEMA TEMPLATE.RAW TO ROLE TEMPLATE_R;
GRANT USAGE ON FUTURE FILE FORMATS IN SCHEMA TEMPLATE.INTERMEDIATE TO ROLE TEMPLATE_R;
GRANT USAGE ON FUTURE FILE FORMATS IN SCHEMA TEMPLATE.PRESENTATION TO ROLE TEMPLATE_R;

-- stages
GRANT USAGE, READ ON ALL STAGES IN DATABASE TEMPLATE TO ROLE TEMPLATE_R;
GRANT USAGE, READ ON FUTURE STAGES IN SCHEMA TEMPLATE.RAW TO ROLE TEMPLATE_R;
GRANT USAGE, READ ON FUTURE STAGES IN SCHEMA TEMPLATE.INTERMEDIATE TO ROLE TEMPLATE_R;
GRANT USAGE, READ ON FUTURE STAGES IN SCHEMA TEMPLATE.PRESENTATION TO ROLE TEMPLATE_R;

-- pipes: grants on current pipes need to be manually written out
GRANT MONITOR ON FUTURE PIPES IN SCHEMA TEMPLATE.RAW TO TEMPLATE_R;
GRANT MONITOR ON FUTURE PIPES IN SCHEMA TEMPLATE.INTERMEDIATE TO TEMPLATE_R;
GRANT MONITOR ON FUTURE PIPES IN SCHEMA TEMPLATE.PRESENTATION TO TEMPLATE_R; 

-- stream
GRANT SELECT ON ALL STREAMS IN DATABASE TEMPLATE TO ROLE TEMPLATE_R;
GRANT SELECT ON FUTURE STREAMS IN SCHEMA TEMPLATE.RAW TO ROLE TEMPLATE_R;
GRANT SELECT ON FUTURE STREAMS IN SCHEMA TEMPLATE.INTERMEDIATE TO ROLE TEMPLATE_R;
GRANT SELECT ON FUTURE STREAMS IN SCHEMA TEMPLATE.PRESENTATION TO ROLE TEMPLATE_R;

-- task
GRANT MONITOR ON ALL TASKS IN DATABASE TEMPLATE TO ROLE TEMPLATE_R;
GRANT MONITOR ON FUTURE TASKS IN SCHEMA TEMPLATE.RAW TO ROLE TEMPLATE_R;
GRANT MONITOR ON FUTURE TASKS IN SCHEMA TEMPLATE.INTERMEDIATE TO ROLE TEMPLATE_R;
GRANT MONITOR ON FUTURE TASKS IN SCHEMA TEMPLATE.PRESENTATION TO ROLE TEMPLATE_R;


USE ROLE SECURITYADMIN;
CREATE OR REPLACE ROLE TEMPLATE_RW
    COMMENT = 'Read-Write access for TEMPLATE db. Can''t create infrastructure';

-- Database: inherit from the _R

-- Schemas: inherit from the _R role

-- table
GRANT ALL PRIVELEGES ON ALL TABLES IN DATABASE TEMPLATE TO ROLE TEMPLATE_RW;
GRANT ALL PRIVELEGES ON FUTURE TABLES IN SCHEMA TEMPLATE.RAW TO ROLE TEMPLATE_RW;
GRANT ALL PRIVELEGES ON FUTURE TABLES IN SCHEMA TEMPLATE.INTERMEDIATE TO ROLE TEMPLATE_RW;
GRANT ALL PRIVELEGES ON FUTURE TABLES IN SCHEMA TEMPLATE.PRESENTATION TO ROLE TEMPLATE_RW;

-- view: no extra privileges needed

-- materialized view: no extra privileges needed

-- external table: no extra priveleges needed

-- sequences: no extra priveleges needed

-- stages
GRANT WRITE ON ALL STAGES IN DATABASE TEMPLATE TO ROLE TEMPLATE_RW;
GRANT WRITE ON FUTURE STAGES IN SCHEMA TEMPLATE.RAW TO ROLE TEMPLATE_RW;
GRANT WRITE ON FUTURE STAGES IN SCHEMA TEMPLATE.INTERMEDIATE TO ROLE TEMPLATE_RW;
GRANT WRITE ON FUTURE STAGES IN SCHEMA TEMPLATE.PRESENTATION TO ROLE TEMPLATE_RW;

-- tasks
GRANT OPERATE ON ALL TASKS IN DATABASE TEMPLATE TO ROLE TEMPLATE_RW;
GRANT OPERATE ON FUTURE TASKS IN SCHEMA TEMPLATE.RAW TO ROLE TEMPLATE_RW;
GRANT OPERATE ON FUTURE TASKS IN SCHEMA TEMPLATE.INTERMEDIATE TO ROLE TEMPLATE_RW;
GRANT OPERATE ON FUTURE TASKS IN SCHEMA TEMPLATE.PRESENTATION TO ROLE TEMPLATE_RW;

-- streams: no extra priveleges needed

-- file format: no extra priveleges needed

-- pipe: current pipes need manual ACL written for them
-- GRANT MONITOR, OPERATE ON TASK __ IN DATABASE TEMPLATE TO ROLE TEMPLATE_RW;
GRANT MONITOR, OPERATE ON FUTURE TASKS IN SCHEMA TEMPLATE.RAW TO ROLE TEMPLATE_RW;
GRANT MONITOR, OPERATE ON FUTURE TASKS IN SCHEMA TEMPLATE.INTERMEDIATE TO ROLE TEMPLATE_RW;
GRANT MONITOR, OPERATE ON FUTURE TASKS IN SCHEMA TEMPLATE.PRESENTATION TO ROLE TEMPLATE_RW;

-- let _RW assume _R role
GRANT ROLE TEMPLATE_R TO ROLE TEMPLATE_RW;
-------------------------------------------------------
-- Create Database Role for Presentation View 
-------------------------------------------------------
USE ROLE SYSADMIN;
CREATE DATABASE ROLE TEMPLATE.PRESENTATION_R;

USE ROLE SECURITYADMIN;
GRANT USAGE ON DATABASE TEMPLATE TO DATABASE ROLE TEMPLATE.PRESENTATION_R;
GRANT USAGE ON SCHEMA TEMPLATE.PRESENTATION TO DATABASE ROLE TEMPLATE.PRESENTATION_R;
GRANT SELECT ON ALL TABLES IN SCHEMA TEMPLATE.PRESENTATION TO DATABASE ROLE TEMPLATE.PRESENTATION_R;
GRANT SELECT ON FUTURE TABLES IN SCHEMA TEMPLATE.PRESENTATION TO DATABASE ROLE TEMPLATE.PRESENTATION_R;
GRANT SELECT ON ALL VIEWS IN SCHEMA TEMPLATE.PRESENTATION TO DATABASE ROLE TEMPLATE.PRESENTATION_R;
GRANT SELECT ON FUTURE VIEWS IN SCHEMA TEMPLATE.PRESENTATION TO DATABASE ROLE TEMPLATE.PRESENTATION_R;
GRANT SELECT ON ALL MATERIALIZED VIEWS IN SCHEMA TEMPLATE.PRESENTATION TO DATABASE ROLE TEMPLATE.PRESENTATION_R;
GRANT SELECT ON FUTURE MATERIALIZED VIEWS IN SCHEMA TEMPLATE.PRESENTATION TO DATABASE ROLE TEMPLATE.PRESENTATION_R;