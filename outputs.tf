# compute layer
output "compute_hub_info" {
  value = var.deploy_compute ? module.compute[0].hub_info : null
}
output "compute_spoke_info" {
  value = var.deploy_compute ? module.compute[0].spoke_info : null
}
output "compute_ssh_keys_directory" {
  value = var.deploy_compute ? module.compute[0].ssh_keys_directory : null
}