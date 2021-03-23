# hub
output "hub_sub_ocids" { value = oci_core_subnet.network_hub_sub.*.id }
output "hub_sub_display_names" { value = oci_core_subnet.network_hub_sub.*.display_name }
output "hub_sub_are_private" { value = oci_core_subnet.network_hub_sub.*.prohibit_public_ip_on_vnic }
# spoke
output "spoke_sub_ocids" { value = oci_core_subnet.network_spoke_sub.*.id }
output "spoke_sub_display_names" { value = oci_core_subnet.network_spoke_sub.*.display_name }
output "spoke_sub_are_private" { value = oci_core_subnet.network_spoke_sub.*.prohibit_public_ip_on_vnic }

output "services" {
  value = [data.oci_core_services.available_services.services]
}

output "network_details_hub" {
  value = ["vcn display name: ${oci_core_vcn.network_hub_vcn.display_name}",
  "vcn cidr: ${join(", ", oci_core_vcn.network_hub_vcn.cidr_blocks)}",
  "subnet cidrs: ${join(", ", oci_core_subnet.network_hub_sub.*.cidr_block)}"]
}

output "network_details_spoke" {
  value = ["vcn display names: ${join(", ", oci_core_vcn.network_spoke_vcn.*.display_name)}",
    "vcn cidrs: ${join(", ", flatten(oci_core_vcn.network_spoke_vcn.*.cidr_blocks))}",
    "subnet cidrs: ${join(", ", oci_core_subnet.network_spoke_sub.*.cidr_block)}"]
}