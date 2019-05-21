import datetime
import logging
import datetime
import os
import sys
from azure.common.credentials import ServicePrincipalCredentials
from azure.mgmt.resource import ResourceManagementClient
from azure.monitor import MonitorClient

import azure.functions as func


def main(mytimer: func.TimerRequest) -> None:
    utc_timestamp = datetime.datetime.utcnow().replace(
        tzinfo=datetime.timezone.utc).isoformat()

    # setup clients 
    subscription_id = os.environ['AZURE_SUBSCRIPTION_ID']
    credentials = ServicePrincipalCredentials(
        client_id=os.environ['AZURE_CLIENT_ID'],
        secret=os.environ['AZURE_CLIENT_SECRET'],
        tenant=os.environ['AZURE_TENANT_ID']
    )
    rgClient = ResourceManagementClient(credentials, subscription_id)
    mClient = MonitorClient(credentials, subscription_id)

    # retrieve resource groups
    filter_prefix=os.environ['AZURE_RESOURCE_GROUP_PREFIX']
    matcthing_resource_groups = []
    for item in rgClient.resource_groups.list():
        if item.name.startswith(filter_prefix):
            matcthing_resource_groups.append(item.name)

    # check create date for each resource group
    inactivity_window=int(os.environ['AZURE_RESOURCE_GROUP_INACTIVITY'])
    inactivity_date = datetime.datetime.today() - datetime.timedelta(days=inactivity_window)
    groups_to_remove = []
    for rg in matcthing_resource_groups:
        filter = " and ".join([ "eventTimestamp ge {}".format(inactivity_date), "resourceGroupName eq '{}'".format(rg) ])
        select = ",".join([
            "eventTimestamp",
            "eventName",
            "operationName",
            "resourceGroupName"
        ])
        activity_logs = mClient.activity_logs.list( filter=filter, select=select )
        group_active = False;
        for log in activity_logs:
            group_active = True
            break
        if not group_active:
            groups_to_remove.append(rg)

    # remove groups
    async_handles = []
    for rg in groups_to_remove:
        print("deleting resource group: {}".format(rg))
        async_handles.append(rgClient.resource_groups.delete(rg))
    for handle in async_handles:
        handle.wait()

    logging.info('Resource Custodian ran at %s', utc_timestamp)
