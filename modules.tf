module "network" {
  count = var.deploy_network ? 1 : 0
  source = "./modules/network-layer"
  # add another subnet?
  add_subnet = local.add_subnet
  # subnet is public?
  subnet_is_public = local.subnet_is_public
  # region
  region = var.region
  # hub variables
  network_client_premises_cidr = var.network_client_premises_cidr
  network_hub_use_drg = var.network_hub_use_drg
  network_hub_cidr = var.network_hub_cidr
  # spoke variables
  num_spoke_networks = local.num_spoke_networks
  network_spoke_use_sgw = var.network_spoke_use_sgw
  network_spoke_cidr_supernet = var.network_spoke_cidr_supernet
  network_spoke_cidr_supernet_newbits = var.network_spoke_cidr_supernet_newbits
  # common variables
  network_compartment_ocid = local.network_compartment_ocid
  network_name = local.network_name
  network_num_network_partitions = local.network_num_network_partitions
  network_use_ngw = local.network_use_ngw
}

module "compute" {
  depends_on = [ module.network ]
  count = var.deploy_compute ? 1 : 0
  source = "./modules/compute-layer"
  # outputs from network module
  # hub
  hub_sub_ocids = var.deploy_network ? module.network[0].hub_sub_ocids : [local.compute_existing_subnet_ocid["hub"]]
  hub_sub_display_names = var.deploy_network ? module.network[0].hub_sub_display_names : [data.oci_core_subnet.compute_hub_existing_subnet[0].display_name]
  hub_sub_are_private = var.deploy_network ? module.network[0].hub_sub_are_private : [data.oci_core_subnet.compute_hub_existing_subnet[0].prohibit_public_ip_on_vnic]
  # spoke
  spoke_sub_ocids = var.deploy_network ? module.network[0].spoke_sub_ocids : [local.compute_existing_subnet_ocid["spoke"]]
  spoke_sub_display_names = var.deploy_network ? module.network[0].spoke_sub_display_names : [data.oci_core_subnet.compute_spoke_existing_subnet[0].display_name]
  spoke_sub_are_private = var.deploy_network ? module.network[0].spoke_sub_are_private : [data.oci_core_subnet.compute_spoke_existing_subnet[0].prohibit_public_ip_on_vnic]
  # number of spoke networks
  num_spoke_networks = local.num_spoke_networks
  # tenancy
  tenancy_ocid = var.tenancy_ocid
  # region
  region = var.region
  # deploy network?
  deploy_network = var.deploy_network
  # add another subnet?
  add_subnet = local.add_subnet
  # subnet is public?
  subnet_is_public = local.subnet_is_public
  # common variables
  network_name = local.network_name
  compute_name = local.compute_name
  compute_availability_domain = local.compute_availability_domain
  compute_compartment_ocid = local.compute_compartment_ocid
  compute_shape = local.compute_shape
  compute_shape_config_memory_in_gbs = local.compute_shape_config_memory_in_gbs
  compute_shape_config_ocpus = local.compute_shape_config_ocpus
  compute_image_ocid = local.compute_image_ocid
  compute_boot_volume_size_in_gbs = local.compute_boot_volume_size_in_gbs
  compute_num_nodes = local.compute_num_nodes
}