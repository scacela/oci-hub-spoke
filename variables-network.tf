# hub variables
variable "network_hub_compartment_ocid" { default = "" }
variable "network_hub_name" { default = "hub" }
variable "network_hub_num_network_partitions" { default = 2 } # use powers of 2. Defines how large each subnet within the VCN will be, based on the number of network partitions are defined by this variable.
variable "network_hub_use_ngw" { default = true }
variable "network_client_premises_cidr" { default = "172.1.0.0/16" } # placeholder value
variable "network_hub_use_drg" { default = false }
variable "network_hub_cidr" { default = "10.0.0.0/24" }
variable "hub_add_subnet" { default = false }
variable "hub_subnet_b_is_public" { default = true }
# spoke variables
variable "network_spoke_compartment_ocid" { default = "" }
variable "network_spoke_name" { default = "student" } # behaves like a prefix if the number of spokes > 1
variable "network_spoke_num_network_partitions" { default = 2 }
variable "network_spoke_use_ngw" { default = true }
variable "network_spoke_use_sgw" { default = true }
variable "network_spoke_cidr_supernet" { default = "10.1.0.0/16" } # reserved for all spoke VCNs, encompasses all spoke VCNs
variable "network_spoke_cidr_supernet_newbits" { default = 8 } # number of new bits by which to extend the cidr range that is reserved for all spoke VCNs
variable "num_spoke_networks" { default = 3 }
variable "spoke_add_subnet" { default = true }
variable "spoke_subnet_a_is_public" { default = false }
variable "spoke_subnet_b_is_public" { default = false }

locals {
  network_compartment_ocid = {
    hub = var.network_hub_compartment_ocid
    spoke = var.network_spoke_compartment_ocid
  }
  # referenced in compute module
  network_name = {
    hub = var.network_hub_name
    spoke = var.network_spoke_name
  }
  network_num_network_partitions = {
    hub = var.network_hub_num_network_partitions
    spoke = var.network_spoke_num_network_partitions
  }
  network_use_ngw = {
    hub = var.network_hub_use_ngw
    spoke = var.network_spoke_use_ngw
  }
  # locals for case where not deploying a new network and deploying to an existing network (i.e. to a subnet in a VCN)
  num_spoke_networks = var.deploy_network ? var.num_spoke_networks : 1
  add_subnet = map(
      "hub", var.deploy_network ? var.hub_add_subnet : false,
      "spoke", var.deploy_network ? var.spoke_add_subnet : false,
    )
  subnet_is_public = {
    hub_b = var.hub_subnet_b_is_public
    spoke_a = var.spoke_subnet_a_is_public
    spoke_b = var.spoke_subnet_b_is_public
  }
}