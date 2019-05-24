# Function App Setup

## Setup Azure Function

The script `setup_function.sh` is used to setup the required pieces for deploying the Resource Custodian into Azure.  It sets up:

- a resource group
- a storage account for Azure Function App state
- an Azure Function App

The syntax for `setup_function.sh` is as follows:

`./setup_funciton.sh -g <resource group> -l <location> -s <storage account> -f <function app>`

## Configure Azure Function

In order for Resource Custodian to function, it requires some configuration.  The necessary information is as follows:

- the name of the function app defined above
- the resource group defined above
- a service principal with the following information:
  - subscription id
  - tenant id
  - client id
  - client secret
- the prefix of resource groups to monitor
- the inactivity period (in days) for groups to be deleted

The syntax for executing `setup_function_settings.sh` is as follows:

`./setup_function_settings.sh -f <function app> -r <resource group> -t <tenant id> -s <subscription id> -c <client id> -p <client secret> -g <resource prefix> -i <inactivity period>`
