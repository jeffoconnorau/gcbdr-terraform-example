# VM variables
vm_names = ["lax-linux-01", "lax-linux-02", "lax-linux-03", "lax-linux-04"]
machine_type = "e2-small"
zone = "us-west2-c"
project_id = "workload-project_id" # This is where your VMs are created
gcp_bdr_project_id = "backup-project_id" # This is where your Backup Plans and Vaults are created
boot_disk_image = "projects/debian-cloud/global/images/debian-12-bookworm-v20250513"
boot_disk_size = 10
boot_disk_type = "pd-balanced"
data_disk_type = "pd-balanced"
data_disk_size = 10
service_account_email = "000000000000-compute@developer.gserviceaccount.com"
subnetwork = "projects/host-project_id/regions/us-west2/subnetworks/hp-1-sn-1" # This is a subnet in a shared VPC / host project.

# Backup variables
backup_location = "us-west2"
backup_plan_association_location = "us-west2"
us_vm_backup_plan_id = "basic-vm-backup-plan-us-1"
us_disk_backup_plan_id = "basic-disks-backup-plan-us-1"
backup_vault_us_id = "bv-us-mr-01"
backup_vault_au_id = "bv-au-ase1-01"
au_location = "australia-southeast1" # This is a regional reference.
us_location = "us" # This is a multi-region reference.
au_vm_backup_plan_gold_id = "gold-vm-backup-plan-au-1"
au_vm_backup_plan_silver_id = "silver-vm-backup-plan-au-2"
au_vm_backup_plan_bronze_id = "bronze-vm-backup-plan-au-3"
email_notification = "email@example.com"
gchat_space = "spaces/MMMMM9_m9MM"
