resource "google_compute_router" "router" {
  name    = "nat-router" # Router 이름
  region  = var.region # Region 설정
  network = google_compute_network.main.id 
}

resource "google_compute_router_nat" "nat" {
  name   = "nat-config" #Nat 이름
  router = google_compute_router.router.name
  region = google_compute_router.router.region  # Region 설정
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
  nat_ip_allocate_option             = "AUTO_ONLY"

  subnetwork {
    name                    = google_compute_subnetwork.private_subnet_a.self_link
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }
}