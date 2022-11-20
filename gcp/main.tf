terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.43.1"
    }
  }
}

provider "google" {
  project = "chrisvmcloud"
}

locals {
  ssh_pub_key_file = "~/.ssh/id_rsa.pub"
  admin_username   = "iacadmin"
  tag              = ["iac-demo"]
}

data "cloudinit_config" "config" {
  part {
    content_type = "text/x-shellscript"
    filename     = "install.sh"
    content      = templatefile("../scripts/install.sh", { hostname = "webserver03" })
  }
}

resource "google_compute_instance" "gcp_web_server" {
  name         = "webserver03"
  machine_type = "e2-micro"
  zone         = "europe-west4-a"
  tags         = local.tag

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-minimal-2204-lts"
    }
  }

  network_interface {
    network = "default"
    access_config {}
  }

  metadata = {
    ssh-keys = "${local.admin_username}:${file(local.ssh_pub_key_file)}"
  }

  metadata_startup_script = file("install.sh")
}

resource "google_compute_firewall" "iac-demo" {
  name    = "default-allow-http-iac-demo"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = local.tag
}

output "azure_webserver03_public_ip" {
  value = <<GCP
  The GCP webserver has been deployed.
  SSH details: ${local.admin_username}@${google_compute_instance.gcp_web_server.network_interface.0.access_config.0.nat_ip}
  Webserver details: http://${google_compute_instance.gcp_web_server.network_interface.0.access_config.0.nat_ip}
  GCP
}
