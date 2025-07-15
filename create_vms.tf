# This code is compatible with Terraform 4.25.0 and versions that are backward compatible to 4.25.0.
# For information about validating this Terraform code, see https://developer.hashicorp.com/terraform/tutorials/gcp-get-started/google-cloud-platform-build#format-and-validate-the-configuration

provider "google" {
  alias   = "gcp_compute"
  project = var.project_id
  # You might need to specify the region if not all resources in this file use the same one,
  # or if the default region for the provider isn't us-west2.
  # For now, we assume zone is specified in each resource, or region is inherited correctly.
}

resource "google_compute_instance" "vms" {
  for_each = toset(var.vm_names)
  provider = google.gcp_compute
  attached_disk {
    source      = google_compute_disk.data_disks[each.key].name
    device_name = "${each.key}-data-disk"
    mode        = "READ_WRITE"
  }

  boot_disk {
    auto_delete = true
    device_name = each.key

    initialize_params {
      image = var.boot_disk_image
      size  = var.boot_disk_size
      type  = var.boot_disk_type
    }

    mode = "READ_WRITE"
  }

  can_ip_forward      = false
  deletion_protection = false
  enable_display      = false

  labels = {
    goog-ec-src           = "vm_add-tf"
  }

  machine_type = var.machine_type

  metadata = {
    enable-osconfig = "TRUE"
    enable-oslogin  = "true"
  }

  name = each.key

  network_interface {
    queue_count = 0
    stack_type  = "IPV4_ONLY"
    subnetwork  = var.subnetwork
  }

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
    preemptible         = false
    provisioning_model  = "STANDARD"
  }

  service_account {
    email  = var.service_account_email
    scopes = ["https://www.googleapis.com/auth/devstorage.read_only", "https://www.googleapis.com/auth/logging.write", "https://www.googleapis.com/auth/monitoring.write", "https://www.googleapis.com/auth/service.management.readonly", "https://www.googleapis.com/auth/servicecontrol", "https://www.googleapis.com/auth/trace.append"]
  }

  shielded_instance_config {
    enable_integrity_monitoring = true
    enable_secure_boot          = false
    enable_vtpm                 = true
  }

  zone = var.zone
}

resource "google_compute_disk" "data_disks" {
  for_each = toset(var.vm_names)
  provider = google.gcp_compute
  name  = "${each.key}-disk-1"
  type  = var.data_disk_type
  size  = var.data_disk_size
  zone  = var.zone
}

resource "null_resource" "stop_vms" {
  for_each = toset(var.vm_names)
  depends_on = [google_compute_instance.vms]

  provisioner "local-exec" {
    command = "sleep 15 && gcloud compute instances stop ${each.key} --zone=${var.zone} --project=${var.project_id} || true"
  }
}
