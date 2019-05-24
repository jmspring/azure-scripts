#!/bin/sh

# get input values
while getopts :f:r:t:s:c:p:g:i: option
do
 case "${option}" in
 f) FUNCTION_APP_NAME=${OPTARG};;
 r) RESOURCE_GROUP=${OPTARG};;
 t) AZURE_TENANT_ID=${OPTARG};;
 s) AZURE_SUBSCRIPTION_ID=${OPTARG};;
 c) AZURE_CLIENT_ID=${OPTARG};;
 p) AZURE_CLIENT_SECRET=${OPTARG};;
 g) AZURE_RESOURCE_GROUP_PREFIX=${OPTARG};;
 i) AZURE_RESOURCE_GROUP_INACTIVITY=${OPTARG};;
 *) echo "Please refer to usage guide on GitHub -- ${OPTARG}" >&2
    exit 1 ;;
 esac
done

if [ -z "$AZURE_TENANT_ID" ] || [ -z "$AZURE_SUBSCRIPTION_ID" ] || [ -z "$AZURE_CLIENT_ID" ] || [ -z "$AZURE_CLIENT_SECRET" ] || [ -z "AZURE_RESOURCE_GROUP_PREFIX" ] || [ -z "AZURE_RESOURCE_GROUP_INACTIVITY" ] || [ -z "$FUNCTION_APP_NAME" ] || [ -z "$RESOURCE_GROUP" ]; then
	echo "poop"
    echo "Please refer to usage guide on GitHub" >&2
    exit 1
fi

az functionapp config appsettings set --name $FUNCTION_APP_NAME --resource-group $RESOURCE_GROUP \
	--settings "AZURE_TENANT_ID=$AZURE_TENANT_ID" \
	"AZURE_CLIENT_ID=$AZURE_CLIENT_ID" \
	"AZURE_CLIENT_SECRET=$AZURE_CLIENT_SECRET" \
	"AZURE_SUBSCRIPTION_ID=$AZURE_SUBSCRIPTION_ID" \
	"AZURE_RESOURCE_GROUP_PREFIX=$AZURE_RESOURCE_GROUP_PREFIX" \
	"AZURE_RESOURCE_GROUP_INACTIVITY=$AZURE_RESOURCE_GROUP_INACTIVITY"
