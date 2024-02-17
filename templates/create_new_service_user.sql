/*
    NEW USER CREATION SCRIPT (Service Version)

    #################################################
    ##### Instructions for Use of this Template #####
    #################################################

    WHEN TO USE:
        1. When a team or a process requests an application user that will not have access to MFA and needs to be run programatically

    NAMING CONVENTION:
        ***** Always end the service user name with "_SVC" *****

    HOW TO USE:
        1. Choose your username
        2. Use Ctrl+H to open the find/replace function in your IDE
        3. Make sure the Case sensitivity & match whole word options are off
        4. Find the word "<team/service-name>" and replace with your username
        5. Generate a password for the service user
        6. Decide what functional/service role the user will use, Ctrl+H <TEMPLATE_ROLE>

*/

USE ROLE SECURITYADMIN;

CREATE USER <team/service-name>_SVC
    PASSWORD = 'generate_password'
    LOGIN_NAME = <team/service-name>_SVC -- match the username above
    DISPLAY_NAMe = 'Template Service User' -- can be same as Login Name or more descriptive, purely for administrative purposes
    EMAIL = ''
    DEFAULT_WAREHOUSE = DEMO_WH -- change depending on team function
    DEFAULT_ROLE = <TEMPLATE_ROLE>; -- change depending on team function


GRANT ROLE <TEMPLATE_ROLE> TO USER <team/service-name>_SVC;
