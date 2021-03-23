# locals
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
# add another subnet?
variable "add_subnet" {}
# subnet_is_public
variable "subnet_is_public" {}
# region
variable "region" {}
# hub variables
variable "network_client_premises_cidr" {}
variable "network_hub_use_drg" {}
variable "network_hub_cidr" {}
# spoke variables
variable "num_spoke_networks" {}
variable "network_spoke_use_sgw" {}
variable "network_spoke_cidr_supernet" {}
variable "network_spoke_cidr_supernet_newbits" {}
# common variables
variable "network_compartment_ocid" {}
variable "network_name" {}
variable "network_num_network_partitions" {}
variable "network_use_ngw" {}