resource "kubernetes_cluster_role" "eks_read_only_role" {
  metadata {
    name = "readonly"
  }

  rule {
    api_groups = ["*"]
    resources = ["deployments", "configmaps", "pods", "secrets", "services", "nodes"]
    verbs = ["get", "list", "watch"]
  }
  depends_on = [null_resource.setup_kubectl]
}

resource "kubernetes_cluster_role_binding" "eks_read_only_role_binding" {
  metadata {
    name = "readonly-grp-binding"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.eks_read_only_role.metadata[0].name
  }

  subject {
    kind      = "Group"
    name      = "readonly-grp"
    api_group = "rbac.authorization.k8s.io"
  }
  depends_on = [null_resource.setup_kubectl]
}


resource "kubernetes_cluster_role_binding" "eks_admin_role_binding" {
  metadata {
    name = "admin-grp-binding"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }

  subject {
    kind      = "Group"
    name      = "admin-grp"
    api_group = "rbac.authorization.k8s.io"
  }
  depends_on = [null_resource.setup_kubectl]
}

