# This file defines Backup and DR workload configurations to associate VMs
# with backup plans.

# Provider for the GCE instances in glabco-sp-1
provider "google" {
  alias   = "gcp_compute"
  project = "glabco-sp-1"
  region  = "us-west2" # VMs are in us-west2, so setting region for this provider
}

# Provider for Backup & DR resources in the glabco-bdr-1 project
provider "google" {
  alias   = "gcp_bdr"
  project = "glabco-bdr-1"
  region  = "us-west2" # Backup plan and workload config will be in us-west2
}

# Backup and DR Workload definitions will be added here.
data "google_compute_instance" "lax_linux_01" {
  provider = google.gcp_compute # Use the provider for the project where the VM exists
  name     = "lax-linux-01"
  zone     = "us-west2-c"       # Zone of the lax-linux-01 VM
}

resource "google_backup_dr_workload" "lax_linux_01_backup_workload" {
  provider = google.gcp_bdr     # Use the provider for the Backup/DR project

  project  = "glabco-bdr-1"     # Project where this workload config is stored
  location = "us-west2"         # Location of the workload config & backup plan
  name     = "lax-linux-01-workload" # Name for this workload configuration

  type     = "COMPUTE_INSTANCE"
  asset_name = data.google_compute_instance.lax_linux_01.self_link # Self-link of the VM

  # Backup plan configuration
  backup_plan = "projects/glabco-bdr-1/locations/us-west2/backupPlans/basic-vm-backup-plan-us-1"

  # Other optional fields like 'description', 'labels' can be added if needed.
}

data "google_compute_instance" "lax_linux_02" {
  provider = google.gcp_compute # Use the provider for the project where the VM exists
  name     = "lax-linux-02"
  zone     = "us-west2-c"       # Zone of the lax-linux-02 VM
}

resource "google_backup_dr_workload" "lax_linux_02_backup_workload" {
  provider = google.gcp_bdr     # Use the provider for the Backup/DR project

  project  = "glabco-bdr-1"     # Project where this workload config is stored
  location = "us-west2"         # Location of the workload config & backup plan
  name     = "lax-linux-02-workload" # Name for this workload configuration

  type     = "COMPUTE_INSTANCE"
  asset_name = data.google_compute_instance.lax_linux_02.self_link # Self-link of the VM

  # Backup plan configuration
  backup_plan = "projects/glabco-bdr-1/locations/us-west2/backupPlans/basic-vm-backup-plan-us-1"

  # Other optional fields like 'description', 'labels' can be added if needed.
}
