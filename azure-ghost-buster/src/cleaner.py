import logging
from azure.identity import DefaultAzureCredential
from azure.mgmt.compute import ComputeManagementClient

def get_unattached_disks(subscription_id):
    logging.info(f"Scanning subscription: {subscription_id} for orphaned disks...")
    credential = DefaultAzureCredential()
    compute_client = ComputeManagementClient(credential, subscription_id)
    
    orphaned_disks = []
    
    # List all disks in the subscription
    for disk in compute_client.disks.list():
        # managed_by returns the ID of the VM it's attached to. 
        # If it's None, the disk is orphaned.
        if disk.managed_by is None:
            logging.warning(f"Found orphaned disk: {disk.name} in {disk.location}")
            orphaned_disks.append({
                "name": disk.name,
                "id": disk.id,
                "resource_group": disk.id.split('/')[4]
            })
            
    return orphaned_disks

def delete_disk(subscription_id, resource_group, disk_name):
    credential = DefaultAzureCredential()
    compute_client = ComputeManagementClient(credential, subscription_id)
    
    logging.info(f"Deleting disk: {disk_name}...")
    poller = compute_client.disks.begin_delete(resource_group, disk_name)
    return poller.result() # Wait for deletion to complete