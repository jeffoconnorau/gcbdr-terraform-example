# This code is compatible with Terraform 4.25.0 and versions that are backward compatible to 4.25.0.
# For information about validating this Terraform code, see https://developer.hashicorp.com/terraform/tutorials/gcp-get-started/google-cloud-platform-build#format-and-validate-the-configuration

provider "google" {
  project = "glabco-sp-1"
}

resource "google_compute_instance" "lax-linux-01" {
  attached_disk {
    source      = google_compute_disk.default.name
    device_name = "lax-linux-01-data-disk"
    mode        = "READ_WRITE"
  }

  boot_disk {
    auto_delete = true
    device_name = "lax-linux-01"

    initialize_params {
      image = "projects/debian-cloud/global/images/debian-12-bookworm-v20250513"
      size  = 10
      type  = "pd-balanced"
    }

    mode = "READ_WRITE"
  }

  can_ip_forward      = false
  deletion_protection = false
  enable_display      = false

  labels = {
    goog-ec-src           = "vm_add-tf"
    goog-ops-agent-policy = "v2-x86-template-1-4-0"
  }

  machine_type = "e2-small"

  metadata = {
    enable-osconfig = "TRUE"
    enable-oslogin  = "true"
  }

  name = "lax-linux-01"

  network_interface {
    queue_count = 0
    stack_type  = "IPV4_ONLY"
    subnetwork  = "projects/glabco-hp-1/regions/us-west2/subnetworks/glabco-hp-1-sn-lax1"
  }

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
    preemptible         = false
    provisioning_model  = "STANDARD"
  }

  service_account {
    email  = "208743458050-compute@developer.gserviceaccount.com"
    scopes = ["https://www.googleapis.com/auth/devstorage.read_only", "https://www.googleapis.com/auth/logging.write", "https://www.googleapis.com/auth/monitoring.write", "https://www.googleapis.com/auth/service.management.readonly", "https://www.googleapis.com/auth/servicecontrol", "https://www.googleapis.com/auth/trace.append"]
  }

  shielded_instance_config {
    enable_integrity_monitoring = true
    enable_secure_boot          = false
    enable_vtpm                 = true
  }

  zone = "us-west2-c"
}

resource "google_compute_disk" "default" {
  name  = "lax-linux-01-disk-1"
  type  = "pd-standard"
  size  = 10
  zone  = "us-west2-c"
}

module "ops_agent_policy" {
  source          = "github.com/terraform-google-modules/terraform-google-cloud-operations/modules/ops-agent-policy"
  project         = "glabco-sp-1"
  zone            = "us-west2-c"
  assignment_id   = "goog-ops-agent-v2-x86-template-1-4-0-us-west2-c"
  agents_rule = {
    package_state = "installed"
    version = "latest"
  }
  instance_filter = {
    all = false
    inclusion_labels = [{
      labels = {
        goog-ops-agent-policy = "v2-x86-template-1-4-0"
      }
    }]
  }
}

