# hub variables
variable "network_hub_compartment_ocid" { default = "" }
variable "network_hub_name" { default = "hub" }
variable "network_hub_num_network_partitions" { default = 2 } # use powers of 2. Defines how large each subnet within the VCN will be, based on the number of network partitions are defined by this variable.
variable "network_hub_use_ngw" { default = true }
variable "network_client_premises_cidr" { default = "172.1.0.0/16" } # placeholder value
variable "network_hub_use_drg" { default = false }
variable "network_hub_cidr" { default = "10.0.0.0/24" }
# spoke variables
variable "network_spoke_compartment_ocid" { default = "" }
variable "network_spoke_name" { default = "student" } # behaves like a prefix if the number of spokes > 1
variable "network_spoke_num_network_partitions" { default = 2 }
variable "network_spoke_use_ngw" { default = true }
variable "network_spoke_use_sgw" { default = true }
variable "network_spoke_cidr_supernet" { default = "10.1.0.0/16" } # reserved for all spoke VCNs, encompasses all spoke VCNs
variable "network_spoke_cidr_supernet_newbits" { default = 8 } # number of new bits by which to extend the cidr range that is reserved for all spoke VCNs


locals {
  network_compartment_ocid = {
    hub = var.network_hub_compartment_ocid
    spoke = var.network_spoke_compartment_ocid
  }
  # common
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
}