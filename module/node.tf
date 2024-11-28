resource "google_service_account" "kubernetes" {
  account_id = "kubernetes"
}

resource "google_container_node_pool" "general" {
  name       = "gateway" # Node Pool 이름
  cluster    = google_container_cluster.primary.id # 클러스터 이름
  location = google_container_cluster.primary.location

  node_count = 4 # Node의 갯수
  
  autoscaling {
    min_node_count = 4
    max_node_count = 8
  }

  management {
    auto_repair  = true
    auto_upgrade = true
  }

  node_config {
    disk_size_gb = 30
    preemptible  = false
    machine_type = "e2-standard-4" # Node의 크기

    labels = {
      role = "general"
    }

    service_account = google_service_account.kubernetes.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}

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
