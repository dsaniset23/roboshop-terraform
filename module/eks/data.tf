data "aws_eks_addon_version" "add-on-version" {
  for_each = var.addon_name
  addon_name   = each.key
  kubernetes_version = aws_eks_cluster.main.version
  most_recent        = true
}