import azure.functions as func
import logging
import os
from .cleaner import get_unattached_disks

def main(timer: func.TimerRequest) -> None:
    sub_id = os.getenv("AZURE_SUBSCRIPTION_ID")
    
    disks = get_unattached_disks(sub_id)
    
    if not disks:
        logging.info("No orphaned disks found. Infrastructure is clean.")
    else:
        logging.info(f"Detected {len(disks)} orphaned disks.")
        # In a real project, you might send an email here 
        # instead of auto-deleting to be safe!