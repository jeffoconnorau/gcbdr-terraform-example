# ------------------------------------------------------------------------------
# Terraform Configuration for Google Cloud Backup and DR
#
# This configuration will:
# 1. Enable the Backup and DR API.
# 2. Create a Backup Vault.
#
# IMPORTANT:
# - VM Protection: This code sets up the Backup and DR infrastructure.
#   Configuring backup policies and assigning VMs to backup plans is a
#   separate step done via the GCP Console or gcloud commands.
# ------------------------------------------------------------------------------

terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 6.35.0" # Use a recent version of the Google provider
    }
  }
}

provider "google" {
  project = "glabco-bdr-1"
}

#create a region backup vault
resource "google_backup_dr_backup_vault" "backup-vault-au-1" {
  location                                   = "australia-southeast1"
  backup_vault_id                            = "bv-au-1"
  description                                = "This is a backup vault built by Terraform"
  backup_minimum_enforced_retention_duration = "86400s"
  annotations = {
    gitops = "true"
    tf_env = "test"
  }
  labels = {
    vault_location = "sydney"
    vault_enforced = "1_day"
  }
  force_update = "true"
  access_restriction = "WITHIN_ORGANIZATION" #Possible options are: ACCESS_RESTRICTION_UNSPECIFIED, WITHIN_PROJECT, WITHIN_ORGANIZATION, UNRESTRICTED, WITHIN_ORG_BUT_UNRESTRICTED_FOR_BA
  ignore_inactive_datasources = "true"
  ignore_backup_plan_references = "true"
  allow_missing = "true"
#  effective_time = "2025-05-21T00:00:00Z" # Time to lock the bucket in yyyy-mm-ddThh:mm:ssZ # this is an ISO 8601 time format, where Z symbolises UTC (Zulu) timezone.
}

#create a multi-region backup vault
resource "google_backup_dr_backup_vault" "backup-vault-us-1" {
  location                                   = "us"
  backup_vault_id                            = "bv-us-1"
  description                                = "This is a multi-region backup vault built by Terraform"
  backup_minimum_enforced_retention_duration = "86400s"
  force_update = "true"
  access_restriction = "WITHIN_ORGANIZATION" #Possible options are: ACCESS_RESTRICTION_UNSPECIFIED, WITHIN_PROJECT, WITHIN_ORGANIZATION, UNRESTRICTED, WITHIN_ORG_BUT_UNRESTRICTED_FOR_BA
  ignore_inactive_datasources = "true"
  ignore_backup_plan_references = "true"
  allow_missing = "true"
#  effective_time = "2025-05-21T00:00:00Z" # Time to lock the bucket in yyyy-mm-ddThh:mm:ssZ # this is an ISO 8601 time format, where Z symbolises UTC (Zulu) timezone.
}

#Now for Backup Vault to protect VMs in a different project - add backup vault service agent to that project.
resource "google_project_iam_binding" "svc-account-added-to-infra-project" {
  project = "glabco-sp-1"
  role    = "roles/backupdr.computeEngineOperator" #or use roles/backupdr.diskOperator for Disk only protection
  members = [
     "serviceAccount:${google_backup_dr_backup_vault.backup-vault-au-1.service_account}",
     "serviceAccount:${google_backup_dr_backup_vault.backup-vault-us-1.service_account}"
  ]
}
# Enable Log Analytics in the project - to ensure logs can be used for reporting
resource "google_logging_project_bucket_config" "analytics-enabled-bucket" {
    project          = "glabco-bdr-1"
    location         = "global"
    retention_days   = 300
    enable_analytics = true
    bucket_id        = "_Default"
}
