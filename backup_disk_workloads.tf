# This file defines Backup and DR workload configurations to associate Disks
# with backup plans.

# Backup lax-linux-03 Boot Disk via Disk Protection
resource "google_backup_dr_backup_plan_association" "lax_linux_03_plan_association" {
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

# Backup lax-linux-03 Data Disk via Disk Protection
resource "google_backup_dr_backup_plan_association" "lax_linux_03-d1_plan_association" {
  project  = "glabco-sp-1"
  location = "us-west2"
  resource = google_compute_disk.lax_linux_03_disk_1.id
  backup_plan_association_id          = "lax-linux-03-disk-d1-plan-assoc"
  backup_plan = google_backup_dr_backup_plan.us-disk-backup-plan-1.id
  resource_type= "compute.googleapis.com/Disk" # for Regional Disk use /RegionDisk instead of /Disk
  depends_on = [
    google_compute_disk.lax_linux_03_disk_1
  ]
}

# Backup lax-linux-04 Boot Disk via Disk Protection
resource "google_backup_dr_backup_plan_association" "lax_linux_04_plan_association" {
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

# Backup lax-linux-04 Data Disk via Disk Protection
resource "google_backup_dr_backup_plan_association" "lax_linux_04-d1_plan_association" {
  project  = "glabco-sp-1"
  location = "us-west2"
  resource = google_compute_disk.lax_linux_04_disk_1.id
  backup_plan_association_id          = "lax-linux-04-disk-d1-plan-assoc"
  backup_plan = google_backup_dr_backup_plan.us-disk-backup-plan-1.id
  resource_type= "compute.googleapis.com/Disk" # for Regional Disk use /RegionDisk instead of /Disk
  depends_on = [
    google_compute_disk.lax_linux_04_disk_1
  ]
}
