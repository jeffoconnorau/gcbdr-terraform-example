# Create Backup Plans with multiple Rules

resource "google_backup_dr_backup_plan" "au-backup-plan-1" {
  location       = "australia-southeast1"
  backup_plan_id = "gold-backup-plan-au-1"
  resource_type  = "compute.googleapis.com/Instance"
  backup_vault   = google_backup_dr_backup_vault.backup-vault-au-1.id
  description    = "Terraform created Backup Plan for Gold workloads running in australia-southeast1"
  
  backup_rules {
    rule_id                = "four-hourly-backups"
    backup_retention_days  = 2

    standard_schedule {
      recurrence_type     = "HOURLY" #HOURLY, DAILY, WEEKLY, MONTHLY, YEARLY
      hourly_frequency    = 4 #period between snapshots
      time_zone           = "Australia/Sydney" #UTC is also possible

      backup_window {
        start_hour_of_day = 0 #begin at midnight
        end_hour_of_day   = 24 #complete at midnight
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

resource "google_backup_dr_backup_plan" "au-backup-plan-2" {
  location       = "australia-southeast1"
  backup_plan_id = "silver-backup-plan-au-2"
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

resource "google_backup_dr_backup_plan" "au-backup-plan-3" {
  location       = "australia-southeast1"
  backup_plan_id = "bronze-backup-plan-au-3"
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
