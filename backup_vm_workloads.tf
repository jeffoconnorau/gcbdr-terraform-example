# This file defines Backup and DR workload configurations to associate VMs
# with backup plans.

# Backup and DR Workload definitions will be added here.
resource "google_backup_dr_backup_plan_association" "lax_linux_01_plan_association" {
  provider = google.gcp_bdr
  project  = "glabco-sp-1"
  location = "us-west2"
  resource = google_compute_instance.lax-linux-01.self_link # The resource to associate
  backup_plan_association_id          = "lax-linux-01-basic-plan-assoc"
  backup_plan = google_backup_dr_backup_plan.us-vm-backup-plan-1.id
  resource_type= "compute.googleapis.com/Instance"
  depends_on = [
    google_compute_instance.lax-linux-01
  ]
}

resource "google_backup_dr_backup_plan_association" "lax_linux_02_plan_association" {
  provider = google.gcp_bdr
  project  = "glabco-sp-1"
  location = "us-west2"
  resource = google_compute_instance.lax-linux-02.self_link # The resource to associate
  backup_plan_association_id          = "lax-linux-02-basic-plan-assoc"
  backup_plan = google_backup_dr_backup_plan.us-vm-backup-plan-1.id
  resource_type= "compute.googleapis.com/Instance"
  depends_on = [
    google_compute_instance.lax-linux-02
  ]
}
