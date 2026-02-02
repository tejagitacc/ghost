import azure.functions as func
import logging
import os
from cleaner import get_unattached_disks

app = func.FunctionApp()

# Runs every day at 8:00 AM (CRON: 0 0 8 * * *)
@app.timer_trigger(schedule="0 0 8 * * *", arg_name="mytimer", run_on_startup=True)
def ghost_buster_timer(mytimer: func.TimerRequest) -> None:
    sub_id = os.getenv("AZURE_SUBSCRIPTION_ID")
    
    if not sub_id:
        logging.error("AZURE_SUBSCRIPTION_ID not found in environment variables.")
        return

    disks = get_unattached_disks(sub_id)
    logging.info(f"Ghost Buster completed. Found {len(disks)} orphaned disks.")