output "cluster_name" {
  value = module.eks.cluster_name
}

output "lb_endpoint" {
  value = kubernetes_service.app.status[0].load_balancer[0].ingress[0].hostname
}