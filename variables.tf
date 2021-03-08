variable "region" {}

data "oci_identity_regions" "available_regions" {
  filter {
    name = "name"
    values = [var.region]
    regex = false
  }
}
data "oci_core_services" "available_services" {
  filter {
    name   = "name"
    values = ["All .* Services In Oracle Services Network"]
    regex  = true
  }
}
output "services" {
  value = [data.oci_core_services.available_services.services]
}

output "network_details_hub" {
  value = ["vcn display name: ${oci_core_vcn.hub_vcn.display_name}",
  "vcn cidr: ${join(", ", oci_core_vcn.hub_vcn.cidr_blocks)}",
  "public subnet cidr: ${oci_core_subnet.hub_pub_sub.cidr_block}",
  "private subnet cidr: ${oci_core_subnet.hub_priv_sub.cidr_block}"]
}

output "network_details_spoke" {
  value = ["vcn display names: ${join(", ", oci_core_vcn.spoke_vcn.*.display_name)}",
    "vcn cidrs: ${join(", ", flatten(oci_core_vcn.spoke_vcn.*.cidr_blocks))}",
    "public subnet cidrs: ${join(", ", oci_core_subnet.spoke_pub_sub.*.cidr_block)}",
    "private subnet cidrs: ${join(", ", oci_core_subnet.spoke_priv_sub.*.cidr_block)}"]
}

# hub variables
variable "hub_compartment_ocid" {}
variable "hub_name" { default = "hub" }
variable "client_premises_cidr" { default = "172.1.0.0/16" } # placeholder value
variable "hub_use_drg" { default = true }
variable "hub_cidr" { default = "10.0.0.0/24" }
variable "hub_num_network_partitions" { default = 2 } # use powers of 2. Defines how large each subnet within the VCN will be, based on the number of network partitions are defined by this variable.
# spoke variables
variable "spoke_compartment_ocid" {}
variable "num_spokes" { default = 3 }
variable "spoke_use_ngw" { default = true }
variable "spoke_use_sgw" { default = true }
variable "spoke_name" { default = "student" } # behaves like a prefix if the number of spokes > 1
variable "spoke_cidr_supernet" { default = "10.1.0.0/16" } # reserved for all spoke VCNs, encompasses all spoke VCNs
variable "spoke_cidr_supernet_newbits" { default = 8 } # number of new bits by which to extend the cidr range that is reserved for all spoke VCNs
variable "spoke_num_network_partitions" { default = 2 }

locals {
  # shorthand values
  region = lower(data.oci_identity_regions.available_regions.regions.0.key)
  private = "priv"
  public = "pub"
  subnet = "sub"
  route_table = "rt"
  security_list = "sl"
  virtual_cloud_network = "vcn"
  dynamic_routing_gateway = "drg"
  service_gateway = "sgw"
  internet_gateway = "igw"
  nat_gateway = "ngw"
  local_peering_gateway = "lpg"
}