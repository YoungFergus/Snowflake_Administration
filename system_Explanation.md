# Part 1: Overall Architecture #

A proper Snowflake setup has multiple environments for at minimum a _dev_ and _prod_ environment.
Once you have your first Snowflake account, you'll want to setup the others using the ORGADMIN role

In your primary account, run all infra that isn't the CREATE ACCOUNT statement in file:
    pt_1_account_setup.sql

Likewise run for as many other environments that you need to setup.

# Part 2: Setting Up Basic Monitoring #

We want to have some visibility into what's happening in the Snowflake account.

Solutions such as Datadog are available and provide comprehensive monitoring. However it may take time to integrate 3rd party providers or be impossible for your org to afford. The following steps provide basic monitoring on your Snowflake account.

1. The account admin and whoever else needs to receive alerts will need their emails to be attached to their accounts and verified.
    An email can be attached to a user through: ALTER USER <user_name> SET email = 'email.gmail.com'
2. Once email is attached to a user's identity, they'll need to confirm it through the Snowsight UI
    https://docs.snowflake.com/en/user-guide/ui-snowsight-profile#verify-your-email-address
3. Run the code in file: pt_2_basic_monitoring.sql
    - First we create an email notification integration for the account
    - Second, we create an alert that looks at the information schema and sends an email if any query has ran for more than an hour. Put any alerts like this in the GOVERNANCE.MONITORING schema for easy organization
4. Repeat the steps for each environment you created

# Part 3: Easy Access Control #
While the amount of people participating in Snowflake will vary per organization, we can create a highly scalable access control schema through the use of roles. Let's define a couple concepts that will help form this access system

## Users ##
We'll define users into two categories

1. Personal User - Represents an actual person who will login to the UI to perform various tasks
2. Service User - A Snowflake user that will only be accessed via programmatic means. Staff should never access the UI through a service user. Service users don't have MFA enabled and end with _SVC

## Roles ##
We'll classify roles into 4 different types

1. System Roles: These are the default roles that are created by Snowflake. Out of the box there are 5 system roles in a Snowflake account - [ACCOUNTADMIN, SECURITYADMIN, SYSADMIN, USERADMIN, PUBLIC]. We can create our own system roles such as TAG_ADMIN and TASK_ADMIN as well. We want to minimize access to these roles as much as possible (except PUBLIC). Service Users not related to Snowflake administration *should not* be granted these roles.

2. Access Roles: A role created to grant certain CRUD permissions to other roles.
For each DBT related database, I recommend the creation of 
    - Read-only ("<database-name>_R"): Contains read only permissions in all schemas
    - Read-Write ("<database-name>_RW"): Contains read and certain write permissions for all schemas
    - Presentation Read: Database Role ("<database-name>.presentation_r) - has access to read tables/views of your final presented data

Notes - Access roles get granted to other roles. Personal users shouldn't be granted direct usage of access roles. Service users can be granted access roles though.

If you need to grant a more specific set of permissions in a database not satisfied by the 3 generic access roles, I recommend creating more database roles with tailored permission sets. These will function as additional access roles.

Access roles don't receive grants to warehouses.

3. Functional Roles - Roles created for different team/business functions that inherit the permissions of one or many access roles. These roles are named after the team whose users will be granted this role. Functional roles:
    a. Don't receive direct grants of permissions (except for warehouses)
    b. Sound like team names or job titles
    c. Can be arranged into hierarchies for a specific team
    d. Receive database role & access role grants

4. Service Roles - A custom built role for a service user. They can have a mixture of custom granted CRUD permissions or inherit other roles. Personal users do not use service roles except for testing and debugging purposes. Developers are responsible for scripting out what permissions each service role needs. These are unique roles built for each application.


Finally, inheritance of roles is crucial in Snowflake. If you build a role that can create any infrastructure, you MUST allow the SYSADMIN system role to inherit that role or else you won't be able to perform centralized data object administration!

Also note, certain statement like CREATE OR REPLACE require special alignment of permissions. You should avoid using this statement in a programmatic way.
