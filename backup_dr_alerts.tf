# This file is for configuring alerts related to Google Cloud Backup and DR.

# Resources for logging metric, alert policy, and notification channel will be added here.
resource "google_logging_metric" "backup_dr_failed_jobs_metric" {
  project     = "glabco-sp-1" # Ensure this matches the provider project
  name        = "backup-dr-failed-scheduled-backup-jobs"
  description = "Counts the number of failed scheduled Backup and DR backup jobs."
  filter      = "resource.type=\"backupdr.googleapis.com/BackupDRProject\" AND jsonPayload.jobCategory = \"SCHEDULED_BACKUP\" AND jsonPayload.jobStatus = \"FAILED\""

  metric_descriptor {
    metric_kind = "DELTA"
    value_type  = "INT64"
    unit        = "1"
    labels {
      key         = "job_id"
      value_type  = "STRING"
      description = "The ID of the Backup and DR job."
    }
    # We could add more labels if needed, e.g., job_name, location, etc.
    # For now, job_id seems like a reasonable label.
  }

  label_extractors = {
    "job_id" = "EXTRACT(jsonPayload.jobId)"
    # Add other extractors if corresponding labels are added above.
  }

  # Optional: Set a bucket_options for distribution metrics if needed,
  # but for a simple counter, it's not strictly necessary.

  # Optional: Set value_extractor if the value is not just a count of 1.
  # For counting occurrences, this isn't needed.
}

resource "google_monitoring_notification_channel" "backup_dr_failure_email_channel" {
  project      = "glabco-sp-1" # Ensure this matches the provider project
  display_name = "Backup DR Job Failure Email (jeff@glabco.com)"
  type         = "email"

  labels = {
    email_address = "jeff@glabco.com"
  }

  description = "Email notification channel for Backup and DR job failures, sending to jeff@glabco.com."

  # enabled = true # This is true by default
}

resource "google_monitoring_alert_policy" "backup_dr_job_failure_alert" {
  project      = "glabco-sp-1" # Ensure this matches the provider project
  display_name = "Backup DR Scheduled Backup Job Failed"
  combiner     = "OR"          # How to combine conditions (only one condition here, so OR/AND doesn't matter much)

  conditions {
    display_name = "Log metric: Failed Backup DR Scheduled Backup Jobs > 0 for 5m"
    condition_threshold {
      filter     = "metric.type=\"logging.googleapis.com/user/${google_logging_metric.backup_dr_failed_jobs_metric.name}\" resource.type=\"global\""
      # It's common to also filter by project_id here if the metric is not project-specific by nature,
      # but user-defined logging metrics are typically accessed via their generated name.
      # Example: "metric.type=\"logging.googleapis.com/user/${google_logging_metric.backup_dr_failed_jobs_metric.name}\" resource.type=\"global\" project_id=\"glabco-sp-1\""
      # For now, let's assume "resource.type=global" is sufficient for user-defined metrics.

      comparison = "COMPARISON_GT" # Greater than
      threshold_value = 0           # Threshold is 0 (i.e., > 0 occurrences)
      duration   = "300s"        # 5 minutes alignment period / duration for the condition to be met

      # How often to evaluate the condition.
      # Not explicitly set here, will use Google's default.
      # trigger {
      #   count = 1 # Trigger if condition met once
      # }

      # Aggregation settings
      # We are counting occurrences, so sum is appropriate.
      aggregations {
        alignment_period   = "300s" # 5 minutes
        per_series_aligner = "ALIGN_SUM" # Sum the count of logs in the alignment period
        # cross_series_reducer = "REDUCE_SUM" # If you have multiple time series (e.g. due to labels) and want to aggregate them
        # group_by_fields      = [] # If using cross_series_reducer with grouping
      }
    }
  }

  alert_strategy {
    # Optional: Configure how quickly alerts re-notify or auto-close.
    # auto_close = "3600s" # e.g., 1 hour
  }

  notification_channels = [
    google_monitoring_notification_channel.backup_dr_failure_email_channel.id
  ]

  documentation {
    content = "A scheduled Backup and DR backup job has failed. Please investigate the Backup and DR service in project glabco-sp-1."
    mime_type = "text/markdown"
  }

  # severity = "ERROR" # Default is "SEVERITY_UNSPECIFIED". Can be CRITICAL, ERROR, WARNING, INFO.

  user_labels = {
    "service" = "backup-dr",
    "type"    = "job-failure-alert"
  }

  depends_on = [
    google_logging_metric.backup_dr_failed_jobs_metric,
    google_monitoring_notification_channel.backup_dr_failure_email_channel
  ]
}
