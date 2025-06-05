# This code is compatible with Terraform 4.25.0 and versions that are backward compatible to 4.25.0.
# For information about validating this Terraform code, see https://developer.hashicorp.com/terraform/tutorials/gcp-get-started/google-cloud-platform-build#format-and-validate-the-configuration

provider "google" {
  project = "glabco-sp-1"
}

resource "google_compute_instance" "lax-linux-01" {
  attached_disk {
    source      = google_compute_disk.lax_linux_01_disk_1.name
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

resource "google_compute_disk" "lax_linux_01_disk_1" {
  name  = "lax-linux-01-disk-1"
  type  = "pd-standard"
  size  = 10
  zone  = "us-west2-c"
}

resource "null_resource" "stop_lax_linux_01" {
  depends_on = [google_compute_instance.lax-linux-01]

  provisioner "local-exec" {
    command = "sleep 30 && gcloud compute instances stop lax-linux-01 --zone=us-west2-c --project=glabco-sp-1 || true"
  }
}

resource "google_compute_instance" "lax-linux-02" {
  attached_disk {
    source      = google_compute_disk.lax_linux_02_disk_1.name
    device_name = "lax-linux-02-data-disk"
    mode        = "READ_WRITE"
  }

  boot_disk {
    auto_delete = true
    device_name = "lax-linux-02"

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
  }

  machine_type = "e2-small"

  metadata = {
    enable-osconfig = "TRUE"
    enable-oslogin  = "true"
  }

  name = "lax-linux-02"

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

resource "google_compute_disk" "lax_linux_02_disk_1" {
  name  = "lax-linux-02-disk-1"
  type  = "pd-standard"
  size  = 10
  zone  = "us-west2-c"
}

resource "null_resource" "stop_lax_linux_02" {
  depends_on = [google_compute_instance.lax-linux-02]

  provisioner "local-exec" {
    command = "sleep 30 && gcloud compute instances stop lax-linux-02 --zone=us-west2-c --project=glabco-sp-1 || true"
  }
}

resource "google_compute_instance" "lax-linux-03" {
  attached_disk {
    source      = google_compute_disk.lax_linux_03_disk_1.name
    device_name = "lax-linux-03-data-disk"
    mode        = "READ_WRITE"
  }

  boot_disk {
    auto_delete = true
    device_name = "lax-linux-03"

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
  }

  machine_type = "e2-small"

  metadata = {
    enable-osconfig = "TRUE"
    enable-oslogin  = "true"
  }

  name = "lax-linux-03"

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

resource "google_compute_disk" "lax_linux_03_disk_1" {
  name  = "lax-linux-03-disk-1"
  type  = "pd-standard"
  size  = 10
  zone  = "us-west2-c"
}

resource "null_resource" "stop_lax_linux_03" {
  depends_on = [google_compute_instance.lax-linux-03]

  provisioner "local-exec" {
    command = "sleep 30 && gcloud compute instances stop lax-linux-03 --zone=us-west2-c --project=glabco-sp-1 || true"
  }
}

resource "google_compute_instance" "lax-linux-04" {
  attached_disk {
    source      = google_compute_disk.lax_linux_04_disk_1.name
    device_name = "lax-linux-04-data-disk"
    mode        = "READ_WRITE"
  }

  boot_disk {
    auto_delete = true
    device_name = "lax-linux-04"

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
  }

  machine_type = "e2-small"

  metadata = {
    enable-osconfig = "TRUE"
    enable-oslogin  = "true"
  }

  name = "lax-linux-04"

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

resource "google_compute_disk" "lax_linux_04_disk_1" {
  name  = "lax-linux-04-disk-1"
  type  = "pd-standard"
  size  = 10
  zone  = "us-west2-c"
}

resource "null_resource" "stop_lax_linux_04" {
  depends_on = [google_compute_instance.lax-linux-04]

  provisioner "local-exec" {
    command = "sleep 30 && gcloud compute instances stop lax-linux-04 --zone=us-west2-c --project=glabco-sp-1 || true"
  }
}

