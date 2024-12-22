module "gke" {
    source = "./module"
    project-id = "gold-vault-444715-k7"
    cluster-name = "yoger"
    region = "asia-northeast3"
    subneta-name = "private-a"
    subnetb-name = "private-b"
    db-password = "qwer1234!"
    redis-password = "qwer1234!"
}