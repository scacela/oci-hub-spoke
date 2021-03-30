# locals
locals {
  # shorthand values
  region = lower(data.oci_identity_regions.available_regions.regions.0.key)
  private = "priv"
  public = "pub"
  compute_instance = "compute"
  subnet = "sub"
  # directory for newly generated private ssh keys
  ssh_keys_dir_path = "~/keys"
  # directory for host ips
  host_file_path = "~/hosts"
}
# outputs from network module
variable "hub_sub_ocids" {}
variable "hub_sub_display_names" {}
variable "hub_sub_are_private" {}
variable "spoke_sub_ocids" {}
variable "spoke_sub_display_names" {}
variable "spoke_sub_are_private" {}
# tenancy
variable "tenancy_ocid" {}
# region
variable "region" {}
# number of spoke networks
variable "num_spoke_networks" {}
# deploy network?
variable "deploy_network" {}
# add another subnet?
variable "add_subnet" {}
# subnet_is_public
variable "subnet_is_public" {}
# common variables
variable "network_name" {}
variable "compute_name" {}
variable "compute_availability_domain" {}
variable "compute_compartment_ocid" {}
variable "compute_shape" {}
variable "compute_shape_config_memory_in_gbs" {}
variable "compute_shape_config_ocpus" {}
variable "compute_image_ocid" {}
variable "compute_boot_volume_size_in_gbs" {}
variable "compute_num_nodes" {}