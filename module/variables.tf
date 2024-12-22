variable "project-id" {
    description = "GCP Project ID"
}

variable "cluster-name" {
    description = "GKE cluster name"
}

variable "region" {
    description = "GCP Region" 
}

variable "subneta-name" {
    description = "private subnet 1 name" 
}

variable "subnetb-name" {
    description = "private subnet 2 name" 
}

variable "zones" {
    type = list(string)
    default = ["asia-northeast3-a", "asia-northeast3-b"]
}

variable "db-password"{
    type = string
}

variable "redis-password"{
    type = string
}