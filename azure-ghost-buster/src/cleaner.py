import logging
from azure.identity import DefaultAzureCredential
from azure.mgmt.compute import ComputeManagementClient

def get_unattached_disks(subscription_id):
    logging.info(f"Scanning subscription {subscription_id} for orphaned disks...")
    credential = DefaultAzureCredential()
    compute_client = ComputeManagementClient(credential, subscription_id)
    
    orphaned_disks = []
    for disk in compute_client.disks.list():
        # If managed_by is None, the disk isn't attached to a VM
        if disk.managed_by is None:
            logging.warning(f"Found orphaned disk: {disk.name}")
            orphaned_disks.append({
                "name": disk.name,
                "resource_group": disk.id.split('/')[4]
            })
    return orphaned_disks