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