# This file defines Backup and DR workload configurations to associate Disks
# with backup plans.

# Backup and DR Workload definitions will be added here.
resource "google_backup_dr_backup_plan_association" "lax_linux_03_plan_association" {
  provider = google.gcp_bdr
  project  = "glabco-sp-1"
  location = "us-west2"
  resource = google_compute_instance.lax-linux-03.boot_disk[0].source
  #resource = google_compute_disk.lax-linux-03.boot_disk[0].device_name
  #resource = google_compute_instance.lax-linux-03.name
  #resource = data.google_compute_disk.lax-linux-03.id
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
  resource = google_compute_disk.lax_linux_03_disk_1.id
  backup_plan_association_id          = "lax-linux-03-disk-d1-plan-assoc"
  backup_plan = google_backup_dr_backup_plan.us-disk-backup-plan-1.id
  resource_type= "compute.googleapis.com/Disk" # for Regional Disk use /RegionDisk instead of /Disk
  depends_on = [
    google_compute_disk.lax_linux_03_disk_1
  ]
}

#resource "google_backup_dr_backup_plan_association" "lax_linux_04_plan_association" {
#  provider = google.gcp_bdr
#  project  = "glabco-sp-1"
#  location = "us-west2"
#  resource = google_compute_instance.lax-linux-04.boot_disk[0].source
#  #resource = google_compute_instance.lax-linux-04.id
#  backup_plan_association_id          = "lax-linux-04-disk-plan-assoc"
#  resource_type= "compute.googleapis.com/Disk" # for Regional Disk use /RegionDisk instead of /Disk
#  depends_on = [
#    google_compute_instance.lax-linux-04
#  ]
# }

resource "google_backup_dr_backup_plan_association" "lax_linux_04-d1_plan_association" {
  provider = google.gcp_bdr
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
