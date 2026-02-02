# Azure Ghost Buster 👻
An automated FinOps tool built with **Terraform** and **Python** to identify and clean orphaned Azure resources.

## Features
- **Managed Identity:** Zero-trust authentication (no secrets stored).
- **Automated Scanning:** Uses Python SDK to detect unattached Managed Disks.
- **IaC:** Fully deployed via Terraform.

## How to Deploy
1. `cd infra`
2. `terraform init && terraform apply`
3. Deploy the Python code using Azure Functions Core Tools: `func azure functionapp publish <func_name>`