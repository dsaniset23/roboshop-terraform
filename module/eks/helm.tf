resource "helm_release" "argocd" {
  depends_on = [null_resource.kube-bootstrap]
  name = "argocd"
  namespace = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  create_namespace = true
  wait             = false
}