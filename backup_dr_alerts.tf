# This file is for configuring alerts related to Google Cloud Backup and DR.
# Resources for logging metric, alert policy, and notification channel will be added here.
resource "google_monitoring_notification_channel" "backup_dr_failure_email_channel" {
  provider     = google.gcp_bdr
  project      = var.gcp_bdr_project_id
  display_name = "Backup DR Job Failure Email Address"
  type         = "email"
  labels = {
    email_address = var.email_notification
  }
  description = "Email notification channel for Backup and DR job failures, sending to jeff@glabco.com"
  # enabled = true # This is true by default
}

resource "google_monitoring_notification_channel" "backup_dr_gchat_channel" {
  provider     = google.gcp_bdr
  project      = var.gcp_bdr_project_id
  display_name = "Backup & DR Job Alerts"
  type         = "google_chat"
  labels = {
    space = var.gchat_space
  }
  description  = "Google Chat notification channel for Backup and DR alerts."
  # enabled    = true # Default is true
}

resource "google_monitoring_alert_policy" "backup_dr_job_failure_alert" {
  provider     = google.gcp_bdr
  project      = var.gcp_bdr_project_id
  display_name = "Backup DR Scheduled Backup Job Failed"
  combiner     = "OR"          # How to combine conditions (only one condition here, so OR/AND doesn't matter much)
  severity     = "WARNING"

  conditions {
    display_name = "Log match: Failed Backup DR Scheduled Backup Jobs"
    condition_matched_log {
      filter = "resource.type=\"backupdr.googleapis.com/BackupDRProject\" AND jsonPayload.jobCategory = \"SCHEDULED_BACKUP\" AND jsonPayload.jobStatus = \"FAILED\""
      # Optional: Add label extractors if needed for the notification content,
      # similar to how they were in the logging_metric.
       label_extractors = {
         "backupVaultName" = "EXTRACT(jsonPayload.backupVaultName)",
         "backupPlanName" = "EXTRACT(jsonPayload.backupPlanName)",
         "sourceResourceName" = "EXTRACT(jsonPayload.sourceResourceName)",
         "sourceResourceLocation" = "EXTRACT(jsonPayload.sourceResourceLocation)",
         "errorType" = "EXTRACT(jsonPayload.errorType)",
         "jobStatus" = "EXTRACT(jsonPayload.jobStatus)",
         "errorCode" = "EXTRACT(jsonPayload.errorCode)"
       }
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
    google_monitoring_notification_channel.backup_dr_failure_email_channel.id,
    google_monitoring_notification_channel.backup_dr_gchat_channel.id
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
    google_monitoring_notification_channel.backup_dr_failure_email_channel,
    google_monitoring_notification_channel.backup_dr_gchat_channel
  ]
}

resource "google_monitoring_alert_policy" "backup_dr_successful_restore_alert" {
  provider     = google.gcp_bdr
  project      = var.gcp_bdr_project_id
  display_name = "Backup DR Restore Job Successful"
  combiner     = "OR"
  severity     = "WARNING" # Or consider "INFO" for success, but using WARNING as per original for now

  conditions {
    display_name = "Log match: Successful Backup DR Restore Jobs"
    condition_matched_log {
      filter = "resource.type=\"backupdr.googleapis.com/BackupDRProject\" AND jsonPayload.jobCategory = \"RESTORE\" AND jsonPayload.jobStatus = \"SUCCESSFUL\""
       label_extractors = {
         "backupVaultName" = "EXTRACT(jsonPayload.backupVaultName)",
         "ResourceType" = "EXTRACT(jsonPayload.ResourceType)",
         "sourceResourceName" = "EXTRACT(jsonPayload.sourceResourceName)",
         "sourceResourceLocation" = "EXTRACT(jsonPayload.sourceResourceLocation)",
         "restoreResourceName" = "EXTRACT(jsonPayload.restoreResourceName)",
         "restoreResourceLocation" = "EXTRACT(jsonPayload.restoreResourceLocation)",
         "jobStatus" = "EXTRACT(jsonPayload.jobStatus)",
         "jobCategory" = "EXTRACT(jsonPayload.jobCategory)"
       }
    }
  }

  alert_strategy {
    auto_close = "172800s" # Match failure alert's auto_close
    notification_rate_limit {
      period = "1800s" # Match failure alert's rate_limit
    }
  }

  notification_channels = [
    google_monitoring_notification_channel.backup_dr_failure_email_channel.id,
    google_monitoring_notification_channel.backup_dr_gchat_channel.id
  ]

  documentation {
    content = "A Backup and DR restore job has completed successfully in project glabco-bdr-1."
    mime_type = "text/markdown"
  }

  user_labels = {
    "service" = "backup-dr",
    "type"    = "job-success-alert" # Changed type for clarity
  }

  depends_on = [
    google_monitoring_notification_channel.backup_dr_failure_email_channel,
    google_monitoring_notification_channel.backup_dr_gchat_channel
  ]
}

resource "google_monitoring_alert_policy" "backup_dr_failed_restore_alert" {
  provider     = google.gcp_bdr
  project      = var.gcp_bdr_project_id
  display_name = "Backup DR Restore Job Failed"
  combiner     = "OR"
  severity     = "ERROR"

  conditions {
    display_name = "Log match: Failed Backup DR Restore Jobs"
    condition_matched_log {
      filter = "resource.type=\"backupdr.googleapis.com/BackupDRProject\" AND jsonPayload.jobCategory = \"RESTORE\" AND jsonPayload.jobStatus = \"FAILED\""
      # Optional: Add label extractors if needed
       label_extractors = {
         "backupVaultName" = "EXTRACT(jsonPayload.backupVaultName)",
         "ResourceType" = "EXTRACT(jsonPayload.ResourceType)",
         "sourceResourceName" = "EXTRACT(jsonPayload.sourceResourceName)",
         "sourceResourceLocation" = "EXTRACT(jsonPayload.sourceResourceLocation)",
         "restoreResourceName" = "EXTRACT(jsonPayload.restoreResourceName)",
         "restoreResourceLocation" = "EXTRACT(jsonPayload.restoreResourceLocation)",
         "jobStatus" = "EXTRACT(jsonPayload.jobStatus)",
         "jobCategory" = "EXTRACT(jsonPayload.jobCategory)"
       }
    }
  }

  alert_strategy {
    auto_close = "172800s" 
    notification_rate_limit {
      period = "1800s" 
    }
  }

  notification_channels = [
    google_monitoring_notification_channel.backup_dr_failure_email_channel.id,
    google_monitoring_notification_channel.backup_dr_gchat_channel.id
  ]

  documentation {
    content = "A Backup and DR restore job has FAILED in project glabco-bdr-1. Immediate attention may be required."
    mime_type = "text/markdown"
  }

  user_labels = {
    "service" = "backup-dr",
    "type"    = "job-restore-failure-alert"
  }

  depends_on = [
    google_monitoring_notification_channel.backup_dr_failure_email_channel,
    google_monitoring_notification_channel.backup_dr_gchat_channel
  ]
}

resource "google_monitoring_alert_policy" "backup_dr_expiration_event_alert" {
  provider     = google.gcp_bdr
  project      = var.gcp_bdr_project_id
  display_name = "Backup DR Manual Expiration Event"
  combiner     = "OR"
  severity     = "WARNING"

  conditions {
    display_name = "Log match: Backup DR Manual Expiration Event"
    condition_matched_log {
      filter = "protoPayload.methodName = \"google.cloud.backupdr.v1.BackupDR.DeleteBackup\""

      # Optional: Add label extractors if needed
       label_extractors = {
         "principalEmail" = "EXTRACT(protoPayload.authenticationInfo.principalEmail)",
         "currentLocations" = "EXTRACT(protoPayload.resourceLocation.currentLocations)",
         "resourceName" = "EXTRACT(protoPayload.resourceName)",
         "methodName" = "EXTRACT(protoPayload.methodName)",
         "project_id" = "EXTRACT(resource.labels.project_id)",
         "severity" = "EXTRACT(protoPayload.severity)"
       }
    }
  }

  alert_strategy {
    auto_close = "172800s" 
    notification_rate_limit {
      period = "1800s" 
    }
  }

  notification_channels = [
    google_monitoring_notification_channel.backup_dr_failure_email_channel.id,
    google_monitoring_notification_channel.backup_dr_gchat_channel.id
  ]

  documentation {
    content = "A Backup and DR restore job has FAILED in project glabco-bdr-1. Immediate attention may be required."
    mime_type = "text/markdown"
  }

  user_labels = {
    "service" = "backup-dr",
    "type"    = "job-restore-failure-alert"
  }

  depends_on = [
    google_monitoring_notification_channel.backup_dr_failure_email_channel,
    google_monitoring_notification_channel.backup_dr_gchat_channel
  ]
}
