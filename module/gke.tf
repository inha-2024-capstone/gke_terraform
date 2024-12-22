resource "google_container_cluster" "primary" {
  name                     = var.cluster-name # 클러스터 이름
  location                 = var.region #Region 설정


  # multi location, 가용영역을 지정
  node_locations = var.zones 
  remove_default_node_pool = true

  initial_node_count = 1
  
  lifecycle {
    ignore_changes = [
      initial_node_count
    ]
  }
  
  network                  = google_compute_network.main.self_link
  subnetwork               = google_compute_subnetwork.private_subnet_a.name
  networking_mode          = "VPC_NATIVE"

    
  addons_config {
    http_load_balancing {
      disabled = false
    }
    horizontal_pod_autoscaling {
      disabled = false
    }
  }

  release_channel {
    channel = "REGULAR"
  }

  workload_identity_config {
    workload_pool = "${var.project-id}.svc.id.goog" # 워크로드 이름 설정. 보통 <이름>.svc.id.goog 사용
  }

  ip_allocation_policy {
    cluster_secondary_range_name  = "k8s-pod-range"
    services_secondary_range_name = "k8s-service-range"
  }

  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = false
    master_ipv4_cidr_block  = "172.16.0.0/28"
  }
}