# This file defines Backup and DR workload configurations to associate VMs
# with backup plans.

resource "google_backup_dr_backup_plan_association" "vm_plan_association" {
  for_each = {
    "lax-linux-01" = google_compute_instance.vms["lax-linux-01"].id,
    "lax-linux-02" = google_compute_instance.vms["lax-linux-02"].id
  }
  provider                   = google.gcp_bdr
  project                    = var.project_id
  location                   = var.backup_plan_association_location
  resource                   = each.value # The resource to associate
  backup_plan_association_id = "${each.key}-basic-plan-assoc"
  backup_plan                = google_backup_dr_backup_plan.us-vm-backup-plan-1.id
  resource_type              = "compute.googleapis.com/Instance"
  depends_on = [
    google_compute_instance.vms
  ]
}
