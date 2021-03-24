# output "compute_details_hub" {
#   value = ["hub public compute display names: ${join(", ", oci_core_instance.hub_pub_compute.*.display_name})}",
#     "hub public compute public ip addresses: ${join(", ", oci_core_instance.hub_pub_compute.*.public_ip})}",
#     "hub public compute private ip addresses: ${join(", ", oci_core_instance.hub_pub_compute.*.private_ip})}",

#     "hub private compute private ip addresses: ${join(", ", oci_core_instance.hub_pub_compute.*.private_ip})}"]
# }

# output "compute_details_spoke" {
#   value = ["spoke public compute display names: ${join(", ", oci_core_instance.spoke_pub_compute.*.display_name})}",
#     "spoke public compute public ip addresses: ${join(", ", oci_core_instance.spoke_pub_compute.*.public_ip})}",
#     "spoke public compute private ip addresses: ${join(", ", oci_core_instance.spoke_pub_compute.*.private_ip})}",

#     "spoke private compute private ip addresses: ${join(", ", oci_core_instance.spoke_pub_compute.*.private_ip})}"]
# }

locals {
  hub = {
    public_ips = oci_core_instance.hub_compute.*.public_ip
    private_ips = oci_core_instance.hub_compute.*.private_ip
    display_names = oci_core_instance.hub_compute.*.display_name
  }
  spoke = {
    public_ips = oci_core_instance.spoke_compute.*.public_ip
    private_ips = oci_core_instance.spoke_compute.*.private_ip
    display_names = oci_core_instance.spoke_compute.*.display_name
  }
}
output "hub_info" {
  value = local.hub
}
output "spoke_info" {
  value = local.spoke
}
output "ssh_keys_directory" {
  value = local.ssh_keys_directory
}