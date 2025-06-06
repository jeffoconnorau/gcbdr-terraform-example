# This file defines Backup and DR workload configurations to associate Disks
# with backup plans.

# Provider for the GCE instances in glabco-sp-1
provider "google" {
  alias   = "gcp_disk"
  project = "glabco-sp-1"
  region  = "us-west2" # VMs are in us-west2, so setting region for this provider
}

# Backup and DR Workload definitions will be added here.
data "google_compute_disk" "lax_linux_03-d1" {
  provider = google.gcp_disk # Use the provider for the project where the Disk exists
  name     = "lax-linux-03-disk-1"
  zone     = "us-west2-c"       # Zone of the lax-linux-01 VM
}

data "google_compute_disk" "lax_linux_04-d1" {
  provider = google.gcp_disk # Use the provider for the project where the Disk exists
  name     = "lax-linux-04-disk-1"
  zone     = "us-west2-c"       # Zone of the lax-linux-02 VM
}

resource "google_backup_dr_backup_plan_association" "lax_linux_03_plan_association" {
  provider = google.gcp_bdr
  project  = "glabco-sp-1"
  location = "us-west2"
  resource = google_compute_instance.lax-linux-03.boot_disk[0].source
  backup_plan_association_id          = "lax-linux-03-disk-plan-assoc"
  backup_plan = google_backup_dr_backup_plan.us-disk-backup-plan-1.id
  resource_type= "compute.googleapis.com/Disk" # for Regional Disk use /RegionDisk instead of /Disk
  depends_on = [
    google_compute_instance.lax-linux-03
  ]
}

resource "google_backup_dr_backup_plan_association" "lax_linux_03-d1_plan_association" {
  provider = google.gcp_bdr
  project  = "glabco-sp-1"
  location = "us-west2"
  resource = data.google_compute_disk.lax_linux_03-d1.id
  backup_plan_association_id          = "lax-linux-03-disk-d1-plan-assoc"
  backup_plan = google_backup_dr_backup_plan.us-disk-backup-plan-1.id
  resource_type= "compute.googleapis.com/Disk" # for Regional Disk use /RegionDisk instead of /Disk
  depends_on = [
    google_compute_disk.lax_linux_03_disk_1
  ]
}

resource "google_backup_dr_backup_plan_association" "lax_linux_04_plan_association" {
  provider = google.gcp_bdr
  project  = "glabco-sp-1"
  location = "us-west2"
  resource = google_compute_instance.lax-linux-04.boot_disk[0].source
  backup_plan_association_id          = "lax-linux-04-disk-plan-assoc"
  backup_plan = google_backup_dr_backup_plan.us-disk-backup-plan-1.id
  resource_type= "compute.googleapis.com/Disk" # for Regional Disk use /RegionDisk instead of /Disk
  depends_on = [
    google_compute_instance.lax-linux-04
  ]
}

resource "google_backup_dr_backup_plan_association" "lax_linux_04-d1_plan_association" {
  provider = google.gcp_bdr
  project  = "glabco-sp-1"
  location = "us-west2"
  resource = data.google_compute_disk.lax_linux_04-d1.id
  backup_plan_association_id          = "lax-linux-04-disk-d1-plan-assoc"
  backup_plan = google_backup_dr_backup_plan.us-disk-backup-plan-1.id
  resource_type= "compute.googleapis.com/Disk" # for Regional Disk use /RegionDisk instead of /Disk
  depends_on = [
    google_compute_disk.lax_linux_04_disk_1
  ]
}
