output "hub_pub_sub_ocid" { value = oci_core_subnet.network_hub_pub_sub.id }
output "hub_priv_sub_ocid" { value = oci_core_subnet.network_hub_priv_sub.id }
output "spoke_pub_sub_ocids" { value = oci_core_subnet.network_spoke_pub_sub.*.id }
output "spoke_priv_sub_ocids" { value = oci_core_subnet.network_spoke_priv_sub.*.id }

output "services" {
  value = [data.oci_core_services.available_services.services]
}

output "network_details_hub" {
  value = ["vcn display name: ${oci_core_vcn.network_hub_vcn.display_name}",
  "vcn cidr: ${join(", ", oci_core_vcn.network_hub_vcn.cidr_blocks)}",
  "public subnet cidr: ${oci_core_subnet.network_hub_pub_sub.cidr_block}",
  "private subnet cidr: ${oci_core_subnet.network_hub_priv_sub.cidr_block}"]
}

output "network_details_spoke" {
  value = ["vcn display names: ${join(", ", oci_core_vcn.network_spoke_vcn.*.display_name)}",
    "vcn cidrs: ${join(", ", flatten(oci_core_vcn.network_spoke_vcn.*.cidr_blocks))}",
    "public subnet cidrs: ${join(", ", oci_core_subnet.network_spoke_pub_sub.*.cidr_block)}",
    "private subnet cidrs: ${join(", ", oci_core_subnet.network_spoke_priv_sub.*.cidr_block)}"]
}