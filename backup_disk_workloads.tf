# This file defines Backup and DR workload configurations to associate Disks
# with backup plans.

resource "google_backup_dr_backup_plan_association" "disk_plan_association" {
  for_each = {
    "lax-linux-03" = google_compute_instance.vms["lax-linux-03"].boot_disk[0].source,
    "lax-linux-04" = google_compute_instance.vms["lax-linux-04"].boot_disk[0].source
  }
  project                    = var.project_id
  location                   = var.backup_plan_association_location
  resource                   = each.value
  backup_plan_association_id = "${each.key}-disk-plan-assoc"
  backup_plan                = google_backup_dr_backup_plan.us-disk-backup-plan-1.id
  resource_type              = "compute.googleapis.com/Disk" # for Regional Disk use /RegionDisk instead of /Disk
  depends_on = [
    google_compute_instance.vms
  ]
}

resource "google_backup_dr_backup_plan_association" "data_disk_plan_association" {
  for_each = {
    "lax-linux-03" = google_compute_disk.data_disks["lax-linux-03"].id,
    "lax-linux-04" = google_compute_disk.data_disks["lax-linux-04"].id
  }
  project                    = var.project_id
  location                   = var.backup_plan_association_location
  resource                   = each.value
  backup_plan_association_id = "${each.key}-disk-d1-plan-assoc"
  backup_plan                = google_backup_dr_backup_plan.us-disk-backup-plan-1.id
  resource_type              = "compute.googleapis.com/Disk" # for Regional Disk use /RegionDisk instead of /Disk
  depends_on = [
    google_compute_disk.data_disks
  ]
}
