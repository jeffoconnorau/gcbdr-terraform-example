# This file is for configuring alerts related to Google Cloud Backup and DR.

#provider "google" {
  project = "glabco-sp-1"
  # Assuming the region might be needed for some monitoring resources,
  # let's add a common one. This can be adjusted if specific resources need otherwise.
  # region  = "us-west1"
#}

# Resources for logging metric, alert policy, and notification channel will be added here.
resource "google_monitoring_notification_channel" "backup_dr_failure_email_channel" {
  display_name = "Backup DR Job Failure Email (jeff@glabco.com)"
  type         = "email"

  labels = {
    email_address = "jeff@glabco.com"
  }

  description = "Email notification channel for Backup and DR job failures, sending to jeff@glabco.com."

  # enabled = true # This is true by default
}

resource "google_monitoring_alert_policy" "backup_dr_job_failure_alert" {
  display_name = "Backup DR Scheduled Backup Job Failed"
  combiner     = "OR"          # How to combine conditions (only one condition here, so OR/AND doesn't matter much)
  severity     = "WARNING"

  conditions {
    display_name = "Log match: Failed Backup DR Scheduled Backup Jobs"
    condition_matched_log {
      filter = "resource.type=\"backupdr.googleapis.com/BackupDRProject\" AND jsonPayload.jobCategory = \"SCHEDULED_BACKUP\" AND jsonPayload.jobStatus = \"FAILED\""
      # Optional: Add label extractors if needed for the notification content,
      # similar to how they were in the logging_metric.
      # label_extractors = {
      #   "job_id" = "EXTRACT(jsonPayload.jobId)"
      # }
    }
  }

  alert_strategy {
    # Optional: Configure how quickly alerts re-notify or auto-close.
    auto_close = "172800s" # e.g., 1 hour
    notification_rate_limit {
      period = "1800s" # 30 minutes in seconds
    }
  }

  notification_channels = [
    google_monitoring_notification_channel.backup_dr_failure_email_channel.id
  ]

  documentation {
    content = "A scheduled Backup and DR backup job has failed. Please investigate the Backup and DR service in project glabco-sp-1."
    mime_type = "text/markdown"
  }

  user_labels = {
    "service" = "backup-dr",
    "type"    = "job-failure-alert"
  }

  depends_on = [
    google_monitoring_notification_channel.backup_dr_failure_email_channel
  ]
}
