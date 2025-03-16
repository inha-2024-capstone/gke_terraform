resource "google_service_account" "kubernetes" {
  account_id = "kubernetes"
}

### Node Pool
resource "google_container_node_pool" "general" {
  name       = "gateway" # Node Pool 이름
  cluster    = google_container_cluster.primary.id # 클러스터 이름
  location = google_container_cluster.primary.location

  ### Min and max value of Node running
  autoscaling {
    min_node_count = 1
    max_node_count = 2
  }

  management {
    auto_repair  = true
    auto_upgrade = true
  }

  ### Node spec
  node_config {
    disk_size_gb = 30
    preemptible  = false
    machine_type = "e2-standard-4" # Node의 크기

    # For SSH
    metadata = {
    ssh-keys = "qwer:${replace(tls_private_key.ssh_key.public_key_openssh, "\n", "")}"
    }

    tags = ["gke-node"]

    labels = {
      role = "general"
    }

    service_account = google_service_account.kubernetes.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
  
}

### Firewall: Inbound
resource "google_compute_firewall" "allow_tcp_to_nodes" {
  name    = "allow-tcp-to-nodes"
  network = google_compute_network.main.name

  allow {
    protocol = "tcp"
    ports    = ["22", "80", "443", "8080", "3000", "8081", "8082", "8083", "8084"]
  }

  source_ranges = ["0.0.0.0/0"]
  source_tags = ["gke-node"]
  target_tags   = ["gke-node"]
}
