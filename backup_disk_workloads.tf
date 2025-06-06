# This file defines Backup and DR workload configurations to associate VMs
# with backup plans.

# Provider for the GCE instances in glabco-sp-1
#provider "google" {
#  alias   = "gcp_compute"
#  project = "glabco-sp-1"
#  region  = "us-west2" # VMs are in us-west2, so setting region for this provider
#}

# Backup and DR Workload definitions will be added here.
data "google_compute_instance" "lax_linux_03" {
  provider = google.gcp_compute # Use the provider for the project where the VM exists
  name     = "lax-linux-03"
  zone     = "us-west2-c"       # Zone of the lax-linux-01 VM
}

data "google_compute_instance" "lax_linux_04" {
  provider = google.gcp_compute # Use the provider for the project where the VM exists
  name     = "lax-linux-04"
  zone     = "us-west2-c"       # Zone of the lax-linux-02 VM
}

#Example for Disk
#resource "google_backup_dr_backup_plan_association" "bpa_1" {
#  backup_plan_association_id = "bpa-1"
#  project               = "vshreyansh-test-project-6"
#  location              = "us-central1"
#  backup_plan           = google_backup_dr_backup_plan.bp_disk_demo.id
#  resource              = "//compute.googleapis.com/projects/vshreyansh-test-project-6/zones/us-central1-a/disks/test-disk"
#  resource_type         = "compute.googleapis.com/Disk"
#}


resource "google_backup_dr_backup_plan_association" "lax_linux_03_plan_association" {
  provider = google.gcp_bdr
  project  = "glabco-sp-1"
  location = "us-west2"
  resource = "//compute.googleapis.com/projects/glabco-sp-1/zones/us-west2-c/disks/lax-linux-03" # The resource to associate
  backup_plan_association_id          = "lax-linux-03-disk-plan-assoc"
  backup_plan = google_backup_dr_backup_plan.us-disk-backup-plan-1.id
  resource_type= "compute.googleapis.com/Disk" # for Regional Disk use /RegionDisk instead of /Disk
}

resource "google_backup_dr_backup_plan_association" "lax_linux_04_plan_association" {
  provider = google.gcp_bdr
  project  = "glabco-sp-1"
  location = "us-west2"
  resource = "//compute.googleapis.com/projects/glabco-sp-1/zones/us-west2-c/disks/lax-linux-04" # The resource to associate
  backup_plan_association_id          = "lax-linux-04-disk-plan-assoc"
  backup_plan = google_backup_dr_backup_plan.us-disk-backup-plan-1.id
  resource_type= "compute.googleapis.com/Disk" # for Regional Disk use /RegionDisk instead of /Disk
}
