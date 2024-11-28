provider "google" {
  project = var.project-id # 프로젝트 ID 입력
  region  = var.region # 배포할 region
}

terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }
  }
}