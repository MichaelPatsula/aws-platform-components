##################
### Networking ###
##################

resource "aws_secretsmanager_secret" "cluster_loadbalancer_subnet_name" {
  name = "${var.name}/cluster-loadbalancer-subnet-name"
}

resource "aws_secretsmanager_secret_version" "cluster_loadbalancer_subnet_name" {
  secret_id     = aws_secretsmanager_secret.cluster_loadbalancer_subnet_name.id
  secret_string = var.kubernetes_cluster.load_balancer_subnet_name
}

