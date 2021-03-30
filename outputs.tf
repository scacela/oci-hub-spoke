# compute layer
output "compute_hub_info" {
  value = local.disqualify ? null : module.compute[0].hub_info
}
output "compute_spoke_info" {
  value = local.disqualify ? null : module.compute[0].spoke_info
}
output "ssh_key" {
  value = local.disqualify ? null : module.compute[0].ssh_key
}
output "sample_access_hub_node" {
  value = local.disqualify ? null : "ssh -i SSH_KEY_PATH -o StrictHostKeyChecking=no opc@${module.compute[0].hub_info.public_ips[0]}"
}
output "sample_access_spoke_node" {
  value = local.disqualify ? null : ["ssh -i SSH_KEY_PATH -o StrictHostKeyChecking=no opc@${module.compute[0].hub_info.public_ips[0]}",
   "ssh -i ${module.compute[0].ssh_keys_dir_path}/${module.compute[0].spoke_info.display_names[0]}.pem -o StrictHostKeyChecking=no ${module.compute[0].spoke_info.private_ips[0]}"]
}

# nullifier in case 0 computes, 0 spokes, or no compute-layer
locals {
  disqualify = local.compute_num_nodes["hub"] == 0 || local.compute_num_nodes["spoke"] == 0 || local.num_spoke_networks == 0 || ! var.deploy_compute ? true : false
}