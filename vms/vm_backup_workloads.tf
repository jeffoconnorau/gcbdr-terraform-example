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

data "google_compute_instance" "lax_linux_02" {
  provider = google.gcp_compute # Use the provider for the project where the VM exists
  name     = "lax-linux-02"
  zone     = "us-west2-c"       # Zone of the lax-linux-02 VM
}

resource "google_backup_dr_backup_plan_association" "lax_linux_01_plan_association" {
  provider = google.gcp_bdr
  project  = "glabco-bdr-1"
  location = "us-west2"
  name     = "lax-linux-01-basic-plan-assoc" # Name for the association resource

  plan     = google_backup_dr_backup_plan.us-vm-backup-plan-1.id
  resource = data.google_compute_instance.lax_linux_01.id # The resource to associate
}

resource "google_backup_dr_backup_plan_association" "lax_linux_02_plan_association" {
  provider = google.gcp_bdr
  project  = "glabco-bdr-1"
  location = "us-west2"
  name     = "lax-linux-02-basic-plan-assoc" # Name for the association resource

  plan     = google_backup_dr_backup_plan.us-vm-backup-plan-1.id
  resource = data.google_compute_instance.lax_linux_02.id # The resource to associate
}
