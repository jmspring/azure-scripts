# Resource Custodian

Resource Custodian is a simple script written as a "Timer Trigger" Azure Function.  When deployed and configured, it will trigger on the configured time period.  Basically, the way it works, is when triggered the script will:

- Determine the list of resource groups within the configured subscription
- Find those that match / start with the configured prefix
- Determine which of the matching resource groups have been inactive in the given period
- Delete those inactive resource groups

## How it works

For Resource Custodian to work, you provide a schedule in the form of a [cron expression](https://en.wikipedia.org/wiki/Cron#CRON_expression)(See the link for full details). A cron expression is a string with 6 separate expressions which represent a given schedule via patterns. The pattern we use to represent every 5 minutes is `0 */5 * * * *`. This, in plain text, means: "When seconds is equal to 0, minutes is divisible by 5, for any hour, day of the month, month, day of the week, or year".

In addition, the following variables must be defined:

- AZURE_SUBSCRIPTION_ID - the ID of one's Azure subnscription
- AZURE_CLIENT_ID - the ID of the service principal the script will use to access Azure
- AZURE_CLIENT_SECRET - the Password of the service principal the script will us to access Azure
- AZURE_TENANT_ID - the ID of the tenant the service principal is from
- AZURE_RESOURCE_GROUP_PREFIX - the prefix that resource groups must match to be considered for deletion (does comparison in lower case)
- AZURE_RESOURCE_GROUP_INACTIVITY - how many 'minutes' of inactivity to consider deleting the identified/matching resource groups
