# locals
locals {
  # shorthand values
  region = lower(data.oci_identity_regions.available_regions.regions.0.key)
  private = "priv"
  public = "pub"
  compute_instance = "compute"
}
# outputs from network module
variable "hub_pub_sub_ocid" {}
variable "hub_priv_sub_ocid" {}
variable "spoke_pub_sub_ocids" {}
variable "spoke_priv_sub_ocids" {}
# tenancy
variable "tenancy_ocid" {}
# region
variable "region" {}
# number of spoke networks
variable "num_spoke_networks" {}
# deploy network?
variable "deploy_network" {}
# hub variables
variable "compute_hub_name" {}
  # public
variable "compute_hub_public_availability_domain" {}
variable "compute_hub_public_compartment_ocid" {}
variable "compute_hub_public_shape" {}
variable "compute_hub_public_shape_config_memory_in_gbs" {}
variable "compute_hub_public_shape_config_ocpus" {}
variable "compute_hub_public_image_ocid" {}
variable "compute_hub_public_boot_volume_size_in_gbs" {}
# variable "compute_hub_public_existing_subnet_ocid" {}
variable "compute_hub_public_num_nodes" {}
variable "compute_hub_public_ssh_public_key" {}
  # private
variable "compute_hub_private_availability_domain" {}
variable "compute_hub_private_compartment_ocid" {}
variable "compute_hub_private_shape" {}
variable "compute_hub_private_shape_config_memory_in_gbs" {}
variable "compute_hub_private_shape_config_ocpus" {}
variable "compute_hub_private_image_ocid" {}
variable "compute_hub_private_boot_volume_size_in_gbs" {}
# variable "compute_hub_private_existing_subnet_ocid" {}
variable "compute_hub_private_num_nodes" {}
variable "compute_hub_private_ssh_public_key" {}
# spoke variables
variable "compute_spoke_name" { default = "student" }
  # public
variable "compute_spoke_public_availability_domain" {}
variable "compute_spoke_public_compartment_ocid" {}
variable "compute_spoke_public_shape" {}
variable "compute_spoke_public_shape_config_memory_in_gbs" {}
variable "compute_spoke_public_shape_config_ocpus" {}
variable "compute_spoke_public_image_ocid" {}
variable "compute_spoke_public_boot_volume_size_in_gbs" {}
# variable "compute_spoke_public_existing_subnet_ocid" {}
variable "compute_spoke_public_num_nodes" {}
variable "compute_spoke_public_ssh_public_key" {}
  # private
variable "compute_spoke_private_availability_domain" {}
variable "compute_spoke_private_compartment_ocid" {}
variable "compute_spoke_private_shape" {}
variable "compute_spoke_private_shape_config_memory_in_gbs" {}
variable "compute_spoke_private_shape_config_ocpus" {}
variable "compute_spoke_private_image_ocid" {}
variable "compute_spoke_private_boot_volume_size_in_gbs" {}
# variable "compute_spoke_private_existing_subnet_ocid" {}
variable "compute_spoke_private_num_nodes" {}
variable "compute_spoke_private_ssh_public_key" {}