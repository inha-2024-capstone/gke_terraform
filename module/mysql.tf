resource "google_sql_database_instance" "mysql_instance" {
  name             = "mysql-instance"
  database_version = "MYSQL_8_0"
  region           = var.region

  settings {
    tier            = "db-n1-standard-1"  # 저렴한 옵션
    availability_type = "ZONAL"       # 단일 가용영역으로 비용 절감
    ip_configuration {
      ipv4_enabled    = false         # Public IP 비활성화
      private_network = google_compute_network.main.self_link
    }
  }
  # Private VPC Connection
  depends_on = [ google_service_networking_connection.private_vpc_connection ]
}

### Mysql User
resource "google_sql_user" "mysql_user" {
  name     = "root"
  instance = google_sql_database_instance.mysql_instance.name
  password = var.db-password # 해당 비밀번호는 main.tf 말고 프롬프트 입력이 더 안전하다.
}

### Database setup
resource "google_sql_database" "example_database" {
  name     = "yoger-db"
  instance = google_sql_database_instance.mysql_instance.name
}

### Firewall: Inbound
resource "google_compute_firewall" "allow_mysql" {
  name    = "allow-mysql-access"
  network = google_compute_network.main.id

  direction = "INGRESS"
  priority  = 1000

  # GKE 노드가 MySQL에 접근 가능하도록 설정
  source_tags = ["gke-node"] # GKE Pod CIDR 범위에 따라 조정 필요

  allow {
    protocol = "tcp"
    ports    = ["3306"] # MySQL 기본 포트
  }
}