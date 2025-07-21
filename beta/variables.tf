# VM variables
variable "vm_names" {
  description = "A list of VM names to create"
  type        = list(string)
}

variable "machine_type" {
  description = "The machine type for the VMs"
  type        = string
}

variable "zone" {
  description = "The zone to create the VMs in"
  type        = string
}

variable "project_id" {
  description = "The project ID to create the VMs in"
  type        = string
}

variable "gcp_bdr_project_id" {
  description = "The project ID for Backup and DR"
  type        = string
}

variable "boot_disk_image" {
  description = "The image to use for the boot disk"
  type        = string
}

variable "boot_disk_size" {
  description = "The size of the boot disk in GB"
  type        = number
}

variable "boot_disk_type" {
  description = "The type of the boot disk"
  type        = string
}

variable "data_disk_type" {
  description = "The type of the data disk"
  type        = string
}

variable "data_disk_size" {
  description = "The size of the data disk in GB"
  type        = number
}

variable "service_account_email" {
  description = "The email of the service account to use for the VMs"
  type        = string
}

variable "subnetwork" {
  description = "The subnetwork to attach the VMs to"
  type        = string
}

# Backup variables
variable "backup_location" {
  description = "The location for the backups"
  type        = string
}

variable "backup_plan_association_location" {
  description = "The location for the backup plan associations"
  type        = string
}

variable "us_vm_backup_plan_id" {
  description = "The ID of the US VM backup plan"
  type        = string
}

variable "us_disk_backup_plan_id" {
  description = "The ID of the US disk backup plan"
  type        = string
}

variable "backup_vault_us_id" {
  description = "The ID of the US backup vault"
  type        = string
}

variable "backup_vault_au_id" {
  description = "The ID of the AU backup vault"
  type        = string
}

variable "au_location" {
  description = "The location for the AU resources"
  type        = string
}

variable "us_location" {
  description = "The location for the US resources"
  type        = string
}

variable "au_vm_backup_plan_gold_id" {
  description = "The ID of the AU VM gold backup plan"
  type        = string
}

variable "au_vm_backup_plan_silver_id" {
  description = "The ID of the AU VM silver backup plan"
  type        = string
}

variable "au_vm_backup_plan_bronze_id" {
  description = "The ID of the AU VM bronze backup plan"
  type        = string
}

variable "email_notification" {
  description = "The email address for backup notifications"
  type        = string
}

variable "gchat_space" {
  description = "The Google Chat space for backup notifications"
  type        = string
}
