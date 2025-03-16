module "gke" {
    source = "./module"
    project-id = "gold-vault-444715-k7" # GCP Project ID
    cluster-name = "yoger" # GKE Cluster Name
    region = "asia-northeast3" # Region
    subneta-name = "private-a" # public subnetwork name
    subnetb-name = "private-b" # private subnetwork name
    db-password = "qwer1234!" # Mysql Password
}