# Create Backup Plans for VMs and Disks with multiple Rules

resource "google_backup_dr_backup_plan" "au-vm-backup-plan-1" {
  provider       = google.gcp_bdr
  location       = var.au_location
  backup_plan_id = var.au_vm_backup_plan_gold_id
  resource_type  = "compute.googleapis.com/Instance"
  backup_vault   = google_backup_dr_backup_vault.backup-vault-au-1.id
  description    = "Terraform created Backup Plan for Gold workloads"
  
  backup_rules {
    rule_id                = "four-hourly-backups"
    backup_retention_days  = 2

    standard_schedule {
      recurrence_type     = "HOURLY" #HOURLY, DAILY, WEEKLY, MONTHLY, YEARLY
      hourly_frequency    = 4 #period between snapshots
      time_zone           = "Australia/Sydney" #UTC is also possible

      backup_window {
        start_hour_of_day = 1 #begin at midnight
        end_hour_of_day   = 7 #complete at midnight
      }
    }
  }
  backup_rules {
    rule_id                = "daily-backup"
    backup_retention_days  = 14

    standard_schedule {
      recurrence_type     = "DAILY" #HOURLY, DAILY, WEEKLY, MONTHLY, YEARLY
      hourly_frequency    = 24
      time_zone           = "Australia/Sydney" #UTC is also possible

      backup_window {
        start_hour_of_day = 0 #backup window opens at midnight
        end_hour_of_day   = 6 #backup window closes at 6am
      }
    }
  }

  backup_rules {
    rule_id                = "weekly-backup"
    backup_retention_days  = 31

    standard_schedule {
      recurrence_type      = "WEEKLY" #HOURLY, DAILY, WEEKLY, MONTHLY, YEARLY
      time_zone            = "Australia/Sydney" #UTC is also possible
      days_of_week         = ["SATURDAY"] #what day to run weekly backup on 
      backup_window {
        start_hour_of_day  = 0 #backup window opens at midnight
        end_hour_of_day    = 6 #backup window closes at 6am
      }
    }
  }
  
  backup_rules {
    rule_id                = "monthly-backup"
    backup_retention_days  = 100

    standard_schedule {
      recurrence_type      = "MONTHLY" #HOURLY, DAILY, WEEKLY, MONTHLY, YEARLY
      time_zone            = "Australia/Sydney" #UTC is also possible
      days_of_month        = [1] #what day of the month to run monthly backup on
      backup_window {
        start_hour_of_day  = 0 #backup window opens at midnight
        end_hour_of_day    = 6 #backup window closes at 6am
      }
    }
  }
}

resource "google_backup_dr_backup_plan" "au-vm-backup-plan-2" {
  provider       = google.gcp_bdr
  location       = var.au_location
  backup_plan_id = var.au_vm_backup_plan_silver_id
  resource_type  = "compute.googleapis.com/Instance"
  backup_vault   = google_backup_dr_backup_vault.backup-vault-au-1.id
  description    = "Terraform created Backup Plan for Silver workloads running in australia-southeast1"

  backup_rules {
    rule_id                = "daily-backup"
    backup_retention_days  = 7

    standard_schedule {
      recurrence_type     = "DAILY" #HOURLY, DAILY, WEEKLY, MONTHLY, YEARLY
      hourly_frequency    = 24
      time_zone           = "Australia/Sydney" #UTC is also possible

      backup_window {
        start_hour_of_day = 0 #backup window opens at midnight
        end_hour_of_day   = 6 #backup window closes at 6am
      }
    }
  }

  backup_rules {
    rule_id                = "weekly-backup"
    backup_retention_days  = 15

    standard_schedule {
      recurrence_type      = "WEEKLY" #HOURLY, DAILY, WEEKLY, MONTHLY, YEARLY
      time_zone            = "Australia/Sydney" #UTC is also possible
      days_of_week         = ["SATURDAY"] #what day to run weekly backup on 
      backup_window {
        start_hour_of_day  = 0 #backup window opens at midnight
        end_hour_of_day    = 6 #backup window closes at 6am
      }
    }
  }
}

resource "google_backup_dr_backup_plan" "au-vm-backup-plan-3" {
  provider       = google.gcp_bdr
  location       = var.au_location
  backup_plan_id = var.au_vm_backup_plan_bronze_id
  resource_type  = "compute.googleapis.com/Instance"
  backup_vault   = google_backup_dr_backup_vault.backup-vault-au-1.id
  description    = "Terraform created Backup Plan for Bronze workloads running in australia-southeast1"

  backup_rules {
    rule_id                = "daily-backup"
    backup_retention_days  = 7

    standard_schedule {
      recurrence_type     = "DAILY" #HOURLY, DAILY, WEEKLY, MONTHLY, YEARLY
      hourly_frequency    = 24
      time_zone           = "Australia/Sydney" #UTC is also possible

      backup_window {
        start_hour_of_day = 0 #backup window opens at midnight
        end_hour_of_day   = 6 #backup window closes at 6am
      }
    }
  }
}

resource "google_backup_dr_backup_plan" "us-vm-backup-plan-1" {
  provider       = google.gcp_bdr
  location       = var.backup_location
  backup_plan_id = var.us_vm_backup_plan_id
  resource_type  = "compute.googleapis.com/Instance"
  backup_vault   = google_backup_dr_backup_vault.backup-vault-us-1.id
  description    = "Terraform created Backup Plan for Basic workloads running in us-west2"

  backup_rules {
    rule_id                = "daily-backup"
    backup_retention_days  = 7

    standard_schedule {
      recurrence_type     = "DAILY" #HOURLY, DAILY, WEEKLY, MONTHLY, YEARLY
      hourly_frequency    = 24
      time_zone           = "America/Los_Angeles" #UTC is also possible

      backup_window {
        start_hour_of_day = 0 #backup window opens at midnight
        end_hour_of_day   = 6 #backup window closes at 6am
      }
    }
  }
}

# Create Backup Plans for Disk with multiple Rules

resource "google_backup_dr_backup_plan" "us-disk-backup-plan-1" {
  provider       = google.gcp_bdr
  location       = var.backup_location
  backup_plan_id = var.us_disk_backup_plan_id
  resource_type  = "compute.googleapis.com/Disk"
  backup_vault   = google_backup_dr_backup_vault.backup-vault-us-1.id
  description    = "Terraform created Backup Plan for Basic Disk running in us-west2"

  backup_rules {
    rule_id                = "daily-backup"
    backup_retention_days  = 7

    standard_schedule {
      recurrence_type     = "DAILY" #HOURLY, DAILY, WEEKLY, MONTHLY, YEARLY
      hourly_frequency    = 24
      time_zone           = "America/Los_Angeles" #UTC is also possible

      backup_window {
        start_hour_of_day = 0 #backup window opens at midnight
        end_hour_of_day   = 6 #backup window closes at 6am
      }
    }
  }
}
