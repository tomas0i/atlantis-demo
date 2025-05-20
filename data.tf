data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_name
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_name
}
data "kubernetes_service" "lb-atlantis" {
  metadata {
    name = "atlantis"
    namespace = helm_release.atlantis.metadata[0].namespace
  }
}

data "aws_secretsmanager_secret" "atlantis_depl_secret" {
  name = var.atlantis_secrets_name
}

data "aws_secretsmanager_secret_version" "atlantis_depl_secret_ver" {
  secret_id = data.aws_secretsmanager_secret.atlantis_depl_secret.id
}
