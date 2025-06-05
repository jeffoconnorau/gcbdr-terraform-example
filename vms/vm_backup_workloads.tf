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

resource "google_backup_dr_backup_plan_association" "my-backup-plan-association" {
  location = "us-central1"
  resource_type= "compute.googleapis.com/Instance"
  backup_plan_association_id          = "my-bpa"
  resource      = google_compute_instance.myinstance.id
  backup_plan  = google_backup_dr_backup_plan.bp1.name
}


resource "google_backup_dr_backup_plan_association" "lax_linux_01_plan_association" {
  provider = google.gcp_bdr
  project  = "glabco-bdr-1"
  location = "us-west2"
  resource_type= "compute.googleapis.com/Instance"
  #name     = "lax-linux-01-basic-plan-assoc" # Name for the association resource
  backup_plan_association_id = "lax-linux-01-basic-plan-assoc"
  resource = data.google_compute_instance.lax_linux_01.self_link # The resource to associate
  #plan     = "projects/glabco-bdr-1/locations/us-west2/backupPlans/basic-vm-backup-plan-us-1"
  backup_plan  = google_backup_dr_backup_plan.basic-vm-backup-plan-us-1.name
}

resource "google_backup_dr_backup_plan_association" "lax_linux_02_plan_association" {
  provider = google.gcp_bdr
  project  = "glabco-bdr-1"
  location = "us-west2"
  resource_type= "compute.googleapis.com/Instance"
  #name     = "lax-linux-02-basic-plan-assoc" # Name for the association resource
  backup_plan_association_id = "lax-linux-01-basic-plan-assoc"
  resource = data.google_compute_instance.lax_linux_02.self_link # The resource to associate
  #plan     = "projects/glabco-bdr-1/locations/us-west2/backupPlans/basic-vm-backup-plan-us-1"
  backup_plan  = google_backup_dr_backup_plan.basic-vm-backup-plan-us-1.name
}
