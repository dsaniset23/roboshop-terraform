terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.37.1"
    }
  }
}
# ------------------------------------------------------------------------------
# 🧠 access_config in aws_eks_cluster:
#
# Controls how IAM authentication to the cluster is handled.
#
# authentication_mode = "CONFIG_MAP"
#   → Uses legacy aws-auth ConfigMap for access control.
#   → You must manually map IAM roles/users in aws-auth.
#
# authentication_mode = "API"
#   → Uses new EKS Access API.
#   → Access managed through aws_eks_access_entry + aws_eks_access_policy_association.
#
# bootstrap_cluster_creator_admin_permissions = true
#   → Gives the cluster creator (whoever creates it via Terraform) admin rights.
#
# ✅ Recommended: Use "API" for new clusters (modern approach).
# ------------------------------------------------------------------------------
# 🧠 EKS Access Management (New API-based model)
#
# ✅ aws_eks_access_entry:
#   - Defines *who* can access the cluster (IAM user/role).
#   - Equivalent to adding entries inside aws-auth ConfigMap (old way).
#   - "principal_arn" = IAM user/role ARN that gets access.
#
# ✅ aws_eks_access_policy_association:
#   - Defines *what level* of access the user/role has.
#   - Associates the principal with a policy like:
#       - AmazonEKSClusterAdminPolicy (full cluster admin)
#       - AmazonEKSViewPolicy (read-only)
#
# 📘 Together:
#   access_entry → who can access
#   access_policy_association → what permissions they have
# ------------------------------------------------------------------------------
# AWS automatically picks the correct EKS-optimized AMI
# based on cluster version, region, and instance type.
# This does NOT use any custom AMI you created earlier.
# To use a custom AMI, you must create a self-managed node group.
# ------------------------------------------------------------------------------
# EKS Deployment Flow
# 1️⃣ Terraform → Creates EKS Cluster + Node Groups
# 2️⃣ Node Groups → Create EC2 worker nodes that auto-join cluster
# 3️⃣ aws_eks_access_entry → Grants IAM role (workstation) cluster access
# 4️⃣ On workstation:
#     aws eks update-kubeconfig --name <cluster-name> --region <region>
# 5️⃣ Verify access:
#     kubectl get nodes
# 6️⃣ Deploy apps:
#     kubectl apply -f <manifest>.yaml
#     (Pods get scheduled automatically onto available nodes)
# ------------------------------------------------------------------------------



resource "aws_eks_cluster" "main" {

  name = "${var.env}-eks"
  role_arn = aws_iam_role.cluster.arn

  vpc_config {
    subnet_ids = var.subnets_ids
  }

  access_config {
    authentication_mode = "API_AND_CONFIG_MAP"
  }

  depends_on = [
    aws_iam_role_policy_attachment.cluster_AmazonEKSClusterPolicy,
  ]

}

resource "aws_eks_addon" "add-ons" {
  for_each = var.addon_name
  cluster_name = aws_eks_cluster.main.name
  addon_name   = each.key
  addon_version = data.aws_eks_addon_version.add-on-version[each.key].version
}

resource "aws_eks_node_group" "main" {
  for_each = var.node_groups
  cluster_name    = aws_eks_cluster.main.name
  node_group_name = each.key
  node_role_arn   = aws_iam_role.node-group-role.arn
  subnet_ids      = var.subnets_ids
  # capacity_type = each.value["capacity_type"]
  instance_types = tolist(each.value["instance_types"])
  disk_size = each.value["disk_size"]

  scaling_config {
    desired_size = each.value["desired_size"]
    max_size     = each.value["max_size"]
    min_size     = each.value["min_size"]
  }

  update_config {
    max_unavailable = each.value["max_unavailable"]
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.roboshop-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.roboshop-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.roboshop-AmazonEC2ContainerRegistryReadOnly,
  ]
}

resource "null_resource" "update_kubeconfig" {
  depends_on = [aws_eks_cluster.main,aws_eks_node_group.main]
  provisioner "local-exec" {
    command = <<EOF
    aws eks update-kubeconfig --name=${aws_eks_cluster.main.name}
    kubectl create namespace argocd
    kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
EOF
  }
}

resource "aws_eks_access_entry" "main" {
  for_each          = var.access_entries
  cluster_name      = aws_eks_cluster.main.name
  principal_arn     = each.value["principal_arn"]
  kubernetes_groups = each.value["kubernetes_groups"]
  type              = "STANDARD"
}

resource "aws_eks_access_policy_association" "main" {
  for_each      = var.access_entries
  cluster_name  = aws_eks_cluster.main.name
  policy_arn    = each.value["policy_arn"]
  principal_arn = each.value["principal_arn"]

  access_scope {
    type       = each.value["type"]
    namespaces = each.value["namespaces"]
  }
}
