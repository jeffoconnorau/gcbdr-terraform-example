# Google Cloud Backup & DR Terraform Example

## Overview

This Terraform configuration provides a working example of how to deploy Google Cloud Backup & DR to protect Compute Engine VMs and their Persistent Disks. It demonstrates a multi-project setup where workloads reside in one project and Backup & DR services (vaults, plans) reside in a dedicated backup project.

## Features

- **Multi-Project Deployment**:
    - Compute Engine VMs and Persistent Disks created in the workload project (`workload-project_id`).
    - Backup Vaults (regional and multi-region) and Backup Plans created in a dedicated Backup & DR admin project (`backup-project_id`).
- **Resource Protection**:
    - Creates 4 Compute Engine VMs (`lax-linux-01` to `lax-linux-04`) with attached data disks.
    - Associates both boot disks and attached data disks with Backup Plans.
- **Backup Configuration**:
    - Defines Backup Vaults in the backup project.
    - Configures Backup Plans with sample backup rules (e.g., daily backups).
- **Cross-Project Permissions**:
    - Grants the Backup Vault service agent necessary IAM permissions in the workload project to back up its VMs and disks.
- **Monitoring & Alerting**:
    - Configures Cloud Logging for backup reporting insights in the backup project.
    - Sets up Cloud Monitoring alert policies for backup job failures and successes, with email and Google Chat notifications.

## Prerequisites

Before applying this Terraform configuration, ensure you have the following:

- **Google Cloud SDK**: Installed and configured (logged in with `gcloud auth application-default login`).
- **Terraform**: Version 0.13.x or newer installed.
- **Google Cloud Projects**:
    - A workload project (hardcoded as `workload-project_id` in this example).
    - A dedicated Backup & DR admin project (hardcoded as `backup-project_id` in this example).
    - Alternatively you could also create all of the resources in the same project, but normally it's better to keep these apart. i.e. backups are external to the project where workloads are.
    - Ensure these projects are created and you have necessary permissions (e.g., Owner, Editor, or sufficient custom roles) to create resources within them.
- **APIs Enabled**: Ensure the following APIs are enabled in the respective projects:
    - In `workload-project_id` (Workload Project):
        - Compute Engine API
    - In `backup-project_id` (Backup & DR Project):
        - Backup and DR API
        - Cloud Logging API
        - Cloud Monitoring API
        - IAM API

## Directory Structure

- `create_vms.tf`: Defines the Compute Engine VMs and their associated data disks in the workload project.
- `backup_vaults.tf`: Configures Backup Vaults in the Backup & DR project and sets up cross-project IAM permissions for the vault's service agent.
- `backup_plans.tf`: Defines Backup Plans (for VMs and Disks) in the Backup & DR project.
- `backup_vm_workloads.tf`: Associates the Compute Engine VMs with Backup Plans.
- `backup_disk_workloads.tf`: Associates the boot disks and data disks of the VMs with Backup Plans.
- `backup_dr_alerts.tf`: Configures monitoring alert policies and notification channels for Backup & DR events.

## Configuration Details

This example uses hardcoded project IDs for simplicity:
- Workload Project (VMs, Disks): `workload-project_id`
- Backup & DR Project (Vaults, Plans, Alerts): `backup-project_id`

If you wish to use different project IDs, you will need to update the `project` attributes in the provider blocks (in `create_vms.tf` and `backup_vaults.tf`) and potentially in resource definitions that explicitly set the project.

It is also recommended to update the Cloud Alerts notification channels to email addresses and or chat spaces that you are associated with.

## Deployment

1.  **Initialize Terraform**:
    ```bash
    terraform init
    ```
2.  **Review Plan**:
    ```bash
    terraform plan
    ```
3.  **Apply Configuration**:
    ```bash
    terraform apply
    ```
    Enter `yes` when prompted to confirm.

4.  **Destroy Resources (Optional)**:
    To remove all resources created by this configuration:
    ```bash
    terraform destroy
    ```
    Enter `yes` when prompted to confirm.

## Key Resources Created

This configuration will create the following main resources:

- **In Workload Project (`workload-project_id`)**:
    - 4 `google_compute_instance` (lax-linux-01 to lax-linux-04)
    - 4 `google_compute_disk` (for attached data disks)
    - `google_backup_dr_backup_plan_association` resources for each VM (lax-linux-01 and lax-linux-02) and disk (lax-linux-03 and lax-linux-04).
    - IAM bindings for the Backup Vault service agent.
- **In Backup & DR Project (`backup-project_id`)**:
    - `google_backup_dr_backup_vault` resources.
    - `google_backup_dr_backup_plan` resources.
    - `google_logging_project_bucket_config` for analytics.
    - `google_monitoring_notification_channel` resources (email, Google Chat).
    - `google_monitoring_alert_policy` resources for backup job status.
