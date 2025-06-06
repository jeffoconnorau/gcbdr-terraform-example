# This file defines Backup and DR workload configurations to associate VMs
# with backup plans.

# Provider for the GCE instances in glabco-sp-1
provider "google" {
  alias   = "gcp_compute"
  project = "glabco-sp-1"
  region  = "us-west2" # VMs are in us-west2, so setting region for this provider
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
  project  = "glabco-sp-1"
  location = "us-west2"
  resource = data.google_compute_instance.lax_linux_01.id # The resource to associate
  backup_plan_association_id          = "lax-linux-01-basic-plan-assoc"
  backup_plan = google_backup_dr_backup_plan.us-vm-backup-plan-1.id
  resource_type= "compute.googleapis.com/Instance"
}

resource "google_backup_dr_backup_plan_association" "lax_linux_02_plan_association" {
  provider = google.gcp_bdr
  project  = "glabco-sp-1"
  location = "us-west2"
  resource = data.google_compute_instance.lax_linux_02.id # The resource to associate
  backup_plan_association_id          = "lax-linux-02-basic-plan-assoc"
  backup_plan = google_backup_dr_backup_plan.us-vm-backup-plan-1.id
  resource_type= "compute.googleapis.com/Instance"
}
