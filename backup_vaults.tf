# ------------------------------------------------------------------------------
# Terraform Configuration for Google Cloud Backup and DR
#
# 1. Create a Backup Vault.
# 2. Configure Log Analytics setting for reporting
#
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
  alias   = "gcp_bdr"
  project = var.gcp_bdr_project_id
}

#create a region backup vault with 1 day enforced retention
resource "google_backup_dr_backup_vault" "backup-vault-au-1" {
  provider                                   = google.gcp_bdr
  location                                   = var.au_location
  backup_vault_id                            = var.backup_vault_au_id
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

#create a multi-region backup vault with 3 days enforced retention
resource "google_backup_dr_backup_vault" "backup-vault-us-1" {
  provider                                   = google.gcp_bdr
  location                                   = "us"
  backup_vault_id                            = var.backup_vault_us_id
  description                                = "This is a multi-region backup vault built by Terraform"
  backup_minimum_enforced_retention_duration = "259200s"
  force_update = "true"
  access_restriction = "WITHIN_ORGANIZATION" #Possible options are: ACCESS_RESTRICTION_UNSPECIFIED, WITHIN_PROJECT, WITHIN_ORGANIZATION, UNRESTRICTED, WITHIN_ORG_BUT_UNRESTRICTED_FOR_BA
  ignore_inactive_datasources = "true"
  ignore_backup_plan_references = "true"
  allow_missing = "true"
#  effective_time = "2025-05-21T00:00:00Z" # Time to lock the bucket in yyyy-mm-ddThh:mm:ssZ # this is an ISO 8601 time format, where Z symbolises UTC (Zulu) timezone.
}

# Now for Backup Vault to protect VMs in a different project - add backup vault service agent to that project.
resource "google_project_iam_binding" "svc-agent-added-to-infra-project" {
  project = var.project_id
  role    = "roles/backupdr.computeEngineOperator" #or use roles/backupdr.diskOperator for Disk only protection
  members = [
     "serviceAccount:${google_backup_dr_backup_vault.backup-vault-au-1.service_account}",
     "serviceAccount:${google_backup_dr_backup_vault.backup-vault-us-1.service_account}"
  ]
}

# Enable Log Analytics in the project - to ensure logs can be used for reporting
resource "google_logging_project_bucket_config" "analytics-enabled-bucket" {
    provider         = google.gcp_bdr
    project          = var.gcp_bdr_project_id
    location         = "global"
    retention_days   = 300
    enable_analytics = true
    bucket_id        = "_Default"
}
