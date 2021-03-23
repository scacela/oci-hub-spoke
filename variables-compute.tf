# Solaris 11.4 (global)
  # vm
  # ocid1.image.oc1..aaaaaaaatmfegrt4uzjgmcemh3vrk46f7ileqcfohhas56hi3pnjhp4nfhoq
  # bm
  # ocid1.image.oc1..aaaaaaaaox5drc6ocosbq7a7jh7beqlvghojoi4b6gjgul26c7jkmizi5a3a
# CentOS-8-2021.02.26-0 (uk-london-1)
  # ocid1.image.oc1.uk-london-1.aaaaaaaakpa2zlibtjh5nrpaewb75k7pl3cy6oibq3hz7psm26uuiok56sfa

# hub
variable "compute_hub_name" { default = "hub" }
variable "compute_hub_availability_domain" { default = 1 }
variable "compute_hub_compartment_ocid" {}
variable "compute_hub_shape" { default = "VM.Standard2.1" }
variable "compute_hub_shape_config_memory_in_gbs" { default = 16 }
variable "compute_hub_shape_config_ocpus" { default = 1 }
variable "compute_hub_image_ocid" { default = "ocid1.image.oc1..aaaaaaaatmfegrt4uzjgmcemh3vrk46f7ileqcfohhas56hi3pnjhp4nfhoq" }
variable "compute_hub_boot_volume_size_in_gbs" { default = 64 }
variable "compute_hub_existing_subnet_ocid" { default = "" }
variable "compute_hub_num_nodes" { default = 2 }
variable "compute_hub_ssh_key" {}
# spoke
variable "compute_spoke_name" { default = "student" }
variable "compute_spoke_availability_domain" { default = 1 }
variable "compute_spoke_compartment_ocid" {}
variable "compute_spoke_shape" { default = "VM.Standard2.1" }
variable "compute_spoke_shape_config_memory_in_gbs" { default = 16 }
variable "compute_spoke_shape_config_ocpus" { default = 1 }
variable "compute_spoke_image_ocid" { default = "ocid1.image.oc1..aaaaaaaatmfegrt4uzjgmcemh3vrk46f7ileqcfohhas56hi3pnjhp4nfhoq" }
variable "compute_spoke_boot_volume_size_in_gbs" { default = 64 }
variable "compute_spoke_existing_subnet_ocid" { default = "" }
variable "compute_spoke_num_nodes" { default = 2 }
variable "compute_spoke_ssh_key" {}

locals {
  compute_name = {
    hub = var.compute_hub_name
    spoke = var.compute_spoke_name
  }
  compute_availability_domain = {
    hub = var.compute_hub_availability_domain
    spoke = var.compute_spoke_availability_domain
  }
  compute_compartment_ocid = {
    hub = var.compute_hub_compartment_ocid
    spoke = var.compute_spoke_compartment_ocid
  }
  compute_shape = {
    hub = var.compute_hub_shape
    spoke = var.compute_spoke_shape
  }
  # used if shape is flex shape
  compute_shape_config_memory_in_gbs = {
    hub = var.compute_hub_shape_config_memory_in_gbs
    spoke = var.compute_spoke_shape_config_memory_in_gbs
  }
  # used if shape is flex shape
  compute_shape_config_ocpus = {
    hub = var.compute_hub_shape_config_ocpus
    spoke = var.compute_spoke_shape_config_ocpus
  }
  compute_image_ocid = {
    hub = var.compute_hub_image_ocid
    spoke = var.compute_spoke_image_ocid
  }
  compute_boot_volume_size_in_gbs = {
    hub = var.compute_hub_boot_volume_size_in_gbs
    spoke = var.compute_spoke_boot_volume_size_in_gbs
  }
  compute_existing_subnet_ocid = {
    hub = var.compute_hub_existing_subnet_ocid
    spoke = var.compute_spoke_existing_subnet_ocid
  }
  compute_num_nodes = {
    hub = var.compute_hub_num_nodes
    spoke = var.compute_spoke_num_nodes
  }
  compute_ssh_key = {
    hub = var.compute_hub_ssh_key
    spoke = var.compute_spoke_ssh_key
  }
}