#!/bin/sh

# get input values
while getopts :g:l:s:f: option
do
 case "${option}" in
 g) RESOURCE_GROUP=${OPTARG};;
 l) LOCATION=${OPTARG};;
 s) STORAGE_ACCOUNT_NAME=${OPTARG};;
 f) FUNCTION_APP_NAME=${OPTARG};;
 *) echo "Please refer to usage guide on GitHub" >&2
    exit 1 ;;
 esac
done

if [ -z "$RESOURCE_GROUP" ] || [ -z "$LOCATION" ] || [ -z "$STORAGE_ACCOUNT_NAME" ] || [ -z "$FUNCTION_APP_NAME" ]; then
    echo "Please refer to usage guide on GitHub" >&2
    exit 1
fi

# create resource group
az group create --name $RESOURCE_GROUP --location $LOCATION

# create storage account
az storage account create --name $STORAGE_ACCOUNT_NAME --location $LOCATION --resource-group $RESOURCE_GROUP --sku Standard_LRS

# create function app
az functionapp create --resource-group $RESOURCE_GROUP --os-type Linux \
	--consumption-plan-location $LOCATION --runtime python \
	--name $FUNCTION_APP_NAME --storage-account $STORAGE_ACCOUNT_NAME
