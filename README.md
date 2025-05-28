# gcbdr
This is a terraform example for Google Cloud Backup & DR that shows a working example of how to deploy it to protect Compute Engine VMs, Persistent Disks, and CloudSQL Databases and store them in a Backup Vault.

1. Configure Backup Vaults (regional and multi-region) in an admin project (dedicated backup project)
2. Backup Plans (with multiple rules) in the backup project
3. Add backup vault 'service agent' privileges to a workload project to project VMs.
4. Configure Cloud Logging for backup reporting insights
5. Configure Cloud Alerts for backup alerts
6. and more...
