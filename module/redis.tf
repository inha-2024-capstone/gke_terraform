resource "google_redis_instance" "my_redis" {
  name           = "my-redis-instance"
  tier           = "BASIC"  # 필요에 따라 BASIC 또는 STANDARD_HA 선택
  memory_size_gb = 1              # 원하는 메모리 크기로 설정
  region         = var.region  # 서브네트워크와 동일한 지역으로 설정

  # 기존 서브네트워크의 self_link를 사용하여 authorized_network 설정
  authorized_network = google_compute_network.main.self_link

  redis_version = "REDIS_7_0"  # 원하는 Redis 버전으로 설정

  # 비밀번호 설정
  auth_enabled = true
}