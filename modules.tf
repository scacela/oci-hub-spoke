module "network" {
  count = var.deploy_network == true ? 1 : 0
  source = "./modules/network-layer"
  # region
  region = var.region
  # hub variables
  network_hub_compartment_ocid = var.network_hub_compartment_ocid
  network_hub_name = var.network_hub_name
  network_client_premises_cidr = var.network_client_premises_cidr
  network_hub_use_drg = var.network_hub_use_drg
  network_hub_cidr = var.network_hub_cidr
  network_hub_num_network_partitions = var.network_hub_num_network_partitions
  # spoke variables
  network_spoke_compartment_ocid = var.network_spoke_compartment_ocid
  num_spoke_networks = var.num_spoke_networks
  network_spoke_use_ngw = var.network_spoke_use_ngw
  network_spoke_use_sgw = var.network_spoke_use_sgw
  network_spoke_name = var.network_spoke_name
  network_spoke_cidr_supernet = var.network_spoke_cidr_supernet
  network_spoke_cidr_supernet_newbits = var.network_spoke_cidr_supernet_newbits
  network_spoke_num_network_partitions = var.network_spoke_num_network_partitions
}

module "compute" {
  count = var.deploy_compute == true ? 1 : 0
  source = "./modules/compute-layer"
  # outputs from network module
  hub_pub_sub_ocid = var.deploy_network ? module.network[0].hub_pub_sub_ocid : var.compute_hub_public_existing_subnet_ocid
  hub_priv_sub_ocid = var.deploy_network ? module.network[0].hub_priv_sub_ocid : var.compute_hub_private_existing_subnet_ocid
  spoke_pub_sub_ocids = var.deploy_network ? module.network[0].spoke_pub_sub_ocids : [var.compute_spoke_public_existing_subnet_ocid]
  spoke_priv_sub_ocids = var.deploy_network ? module.network[0].spoke_priv_sub_ocids : [var.compute_spoke_private_existing_subnet_ocid]
  # number of spoke networks
  num_spoke_networks = var.num_spoke_networks
  # tenancy
  tenancy_ocid = var.tenancy_ocid
  # region
  region = var.region
  # deploy network?
  deploy_network = var.deploy_network
  # hub variables
  compute_hub_name = var.compute_hub_name
    # public
  compute_hub_public_availability_domain = var.compute_hub_public_availability_domain
  compute_hub_public_compartment_ocid = var.compute_hub_public_compartment_ocid
  compute_hub_public_shape = var.compute_hub_public_shape
  compute_hub_public_shape_config_memory_in_gbs = var.compute_hub_public_shape_config_memory_in_gbs
  compute_hub_public_shape_config_ocpus = var.compute_hub_public_shape_config_ocpus
  compute_hub_public_image_ocid = var.compute_hub_public_image_ocid
  compute_hub_public_boot_volume_size_in_gbs = var.compute_hub_public_boot_volume_size_in_gbs
  # compute_hub_public_existing_subnet_ocid = var.compute_hub_public_existing_subnet_ocid
  compute_hub_public_num_nodes = var.compute_hub_public_num_nodes
  compute_hub_public_ssh_public_key = var.compute_hub_public_ssh_public_key
    # private
  compute_hub_private_availability_domain = var.compute_hub_private_availability_domain
  compute_hub_private_compartment_ocid = var.compute_hub_private_compartment_ocid
  compute_hub_private_shape = var.compute_hub_private_shape
  compute_hub_private_shape_config_memory_in_gbs = var.compute_hub_private_shape_config_memory_in_gbs
  compute_hub_private_shape_config_ocpus = var.compute_hub_private_shape_config_ocpus
  compute_hub_private_image_ocid = var.compute_hub_private_image_ocid
  compute_hub_private_boot_volume_size_in_gbs = var.compute_hub_private_boot_volume_size_in_gbs
  # compute_hub_private_existing_subnet_ocid = var.compute_hub_private_existing_subnet_ocid
  compute_hub_private_num_nodes = var.compute_hub_private_num_nodes
  compute_hub_private_ssh_public_key = var.compute_hub_private_ssh_public_key
  # spoke variables
  compute_spoke_name = var.compute_spoke_name
    # public
  compute_spoke_public_availability_domain = var.compute_spoke_public_availability_domain
  compute_spoke_public_compartment_ocid = var.compute_spoke_public_compartment_ocid
  compute_spoke_public_shape = var.compute_spoke_public_shape
  compute_spoke_public_shape_config_memory_in_gbs = var.compute_spoke_public_shape_config_memory_in_gbs
  compute_spoke_public_shape_config_ocpus = var.compute_spoke_public_shape_config_ocpus
  compute_spoke_public_image_ocid = var.compute_spoke_public_image_ocid
  compute_spoke_public_boot_volume_size_in_gbs = var.compute_spoke_public_boot_volume_size_in_gbs
  # compute_spoke_public_existing_subnet_ocid = var.compute_spoke_public_existing_subnet_ocid
  compute_spoke_public_num_nodes = var.compute_spoke_public_num_nodes
  compute_spoke_public_ssh_public_key = var.compute_spoke_public_ssh_public_key
    # private
  compute_spoke_private_availability_domain = var.compute_spoke_private_availability_domain
  compute_spoke_private_compartment_ocid = var.compute_spoke_private_compartment_ocid
  compute_spoke_private_shape = var.compute_spoke_private_shape
  compute_spoke_private_shape_config_memory_in_gbs = var.compute_spoke_private_shape_config_memory_in_gbs
  compute_spoke_private_shape_config_ocpus = var.compute_spoke_private_shape_config_ocpus
  compute_spoke_private_image_ocid = var.compute_spoke_private_image_ocid
  compute_spoke_private_boot_volume_size_in_gbs = var.compute_spoke_private_boot_volume_size_in_gbs
  # compute_spoke_private_existing_subnet_ocid = var.compute_spoke_private_existing_subnet_ocid
  compute_spoke_private_num_nodes = var.compute_spoke_private_num_nodes
  compute_spoke_private_ssh_public_key = var.compute_spoke_private_ssh_public_key
}