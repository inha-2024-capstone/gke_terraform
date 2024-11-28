resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "local_file" "private_key" {
  content  = tls_private_key.ssh_key.private_key_pem
  filename = "./private_key.pem"
}

output "public_key" {
  value = tls_private_key.ssh_key.public_key_openssh
}

resource "google_compute_instance" "bastion" {
  name         = "bastion"
  machine_type = "e2-small"
  zone         = "asia-northeast3-a"

  boot_disk {
    initialize_params {
      image = "projects/debian-cloud/global/images/family/debian-11"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.private_subnet_a.name
    access_config {
      # Assign a public IP
    }
  }
  metadata = {
    ssh-keys = "qwer:${replace(tls_private_key.ssh_key.public_key_openssh, "\n", "")}"
  }

  tags = ["bastion"]

  # Startup script to install kubectl and gcloud
  metadata_startup_script = <<-EOT
    #!/bin/bash
    sudo apt-get update
    sudo apt-get install -y kubectl google-cloud-sdk
  EOT
}

# Output: Bastion Public IP
output "bastion_public_ip" {
  value       = google_compute_instance.bastion.network_interface[0].access_config[0].nat_ip
  description = "Public IP of the Bastion Host"
}

resource "google_compute_firewall" "allow_bastion_to_private" {
  name    = "allow-bastion-to-private"
  network = google_compute_network.main.id

  allow {
    protocol = "tcp"
    ports    = ["22", "443", "6443"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags = ["bastion"]
}