module "gke" {
    source = "./module"
    project-id = "silver-binder-443013-f7"
    cluster-name = "yoger"
    region = "asia-northeast3"
    subneta-name = "private-a"
    subnetb-name = "private-b"
    db-password = "qwer1234!"
}