resource "google_compute_network" "custom-vpc" {
  name                    = "test-tf-network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet" {
  name          = "test-tf-subnetwork"
  ip_cidr_range = "10.2.0.0/16"
  region        = "europe-west2"
  network       = google_compute_network.custom-vpc.id
}

resource "google_compute_firewall" "web-fw" {
  name        = "http-rule"
  network     = google_compute_network.custom-vpc.id
  description = "Creates firewall rule targeting tagged instances"

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  target_tags   = ["web"]
  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_instance" "default" {
  name         = "tf-test-web-vm2"
  machine_type = "g1-small"
  zone         = "europe-west2-b"
  tags         = ["web"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.subnet.self_link

    access_config {
      // Ephemeral public IP
    }
  }

  metadata_startup_script = file("./startup.sh")

  service_account {
    scopes = ["cloud-platform"]
  }
}
