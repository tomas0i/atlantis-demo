#Create a namespace for our application
# resource "kubernetes_namespace" "example" {
#   metadata {
#     name = "example-app"
#   }
# }

resource "kubernetes_storage_class" "ebs_sc_1" {
  metadata {
    name = "ebs-sc-1"
  }
  storage_provisioner = "ebs.csi.aws.com"
  volume_binding_mode = "WaitForFirstConsumer"
  parameters = {
    type      = "gp3"
    encrypted = "true"
  }
  allow_volume_expansion = true

  depends_on = [module.eks]
}

resource "helm_release" "atlantis" {
  name       = "atlantis"
  repository = "https://runatlantis.github.io/helm-charts"
  chart      = "atlantis"
  version    = "5.17.2"
  #namespace  = kubernetes_namespace.example.metadata[0].name

  set {
    name  = "service.type"
    value = "LoadBalancer"
  }

  #TODO use preconfigured dns name and terraform resource to create CNAME entry in Route53
  set {
    name  = "atlantisUrl"
    # use value of "terraform output example_app_load_balancer_hostname"
    value = "http://aa8651be819d34b15b6643e86a1fe00f-220741403.eu-central-1.elb.amazonaws.com"
  }


  set {
    name  = "github.user"
    value = var.github_username
  }

  set {
    name  = "github.token"
    value = jsondecode(data.aws_secretsmanager_secret_version.atlantis_depl_secret_ver.secret_string)["github_token"]
  }

  set {
    name  = "github.secret"
    value = jsondecode(data.aws_secretsmanager_secret_version.atlantis_depl_secret_ver.secret_string)["atlantis_secret"]
  }
  set {
    name  = "aws.credentials"
    value = jsondecode(data.aws_secretsmanager_secret_version.atlantis_depl_secret_ver.secret_string)["atlantis_aws_credentials"]
  }

  set {
    name  = "orgAllowlist"
    value = var.atlantis_repo_allow_list
  }

  set {
    name  = "volumeClaim.enabled"
    value = "true"
  }
  set {
    name  = "volumeClaim.storageClassName"
    value = kubernetes_storage_class.ebs_sc_1.metadata[0].name
  }

  set {
    name  = "volumeClaim.dataStorage"
    value = "6Gi"
  }

  # set {
  #   name  = "aws.config"
  #   value = "[default] \n region = eu-central-1 \n output = json"
  # }

  set {
    name  = "resources.limits.cpu"
    value = "500m"
  }

  set {
    name  = "resources.limits.memory"
    value = "1Gi"
  }
  depends_on = [module.eks]
}




