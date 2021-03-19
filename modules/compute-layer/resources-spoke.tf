# spoke pub compute
resource "oci_core_instance" "spoke_pub_compute" {
    count = var.deploy_network ? var.compute_spoke_public_num_nodes * var.num_spoke_networks : var.compute_spoke_public_num_nodes
    #Required
    availability_domain = data.oci_identity_availability_domain.compute_spoke_public_availability_domain.name
    compartment_id = var.compute_spoke_public_compartment_ocid
    shape = var.compute_spoke_public_shape
    create_vnic_details {
        #Optional
        assign_public_ip = true
        display_name = var.compute_spoke_public_num_nodes == 1 ? "${local.region}-${var.compute_spoke_name}-${local.public}-${local.compute_instance}-${count.index+1}-vnic" : "${local.region}-${var.compute_spoke_name}-${local.public}-${local.compute_instance}-vnic"
        hostname_label = var.compute_spoke_public_num_nodes == 1 ? "${local.region}-${var.compute_spoke_name}-${local.public}-${local.compute_instance}-${count.index+1}" : "${local.region}-${var.compute_spoke_name}-${local.public}-${local.compute_instance}"
        subnet_id = var.deploy_network ? var.spoke_pub_sub_ocids[count.index%var.compute_spoke_public_num_nodes] : var.spoke_pub_sub_ocids[0]
    }
    display_name = var.compute_spoke_public_num_nodes == 1 ? "${local.region}-${var.compute_spoke_name}-${local.public}-${local.compute_instance}-${count.index+1}" : "${local.region}-${var.compute_spoke_name}-${local.public}-${local.compute_instance}"
    fault_domain = "FAULT-DOMAIN-${(count.index%3)+1}"
    dynamic shape_config {
        for_each = var.compute_spoke_public_shape == "VM.Standard.E3.Flex" ? [1] : []
        content {
        #Optional
        memory_in_gbs = var.compute_spoke_public_shape_config_memory_in_gbs
        ocpus = var.compute_spoke_public_shape_config_ocpus
        }
    }
    source_details {
        #Required
        source_id = var.compute_spoke_public_image_ocid
        source_type = "image"
        #Optional
        boot_volume_size_in_gbs = var.compute_spoke_public_boot_volume_size_in_gbs
        # kms_key_id = oci_kms_key.test_key.id
    }
    metadata = {
        ssh_authorized_keys = var.compute_spoke_public_ssh_public_key
    }
    preserve_boot_volume = false
}
# spoke priv compute
resource "oci_core_instance" "spoke_priv_compute" {
    count = var.deploy_network ? var.compute_spoke_private_num_nodes * var.num_spoke_networks : var.compute_spoke_private_num_nodes
    #Required
    availability_domain = data.oci_identity_availability_domain.compute_spoke_private_availability_domain.name
    compartment_id = var.compute_spoke_private_compartment_ocid
    shape = var.compute_spoke_private_shape
    create_vnic_details {
        #Optional
        assign_public_ip = false
        display_name = var.compute_spoke_private_num_nodes == 1 ? "${local.region}-${var.compute_spoke_name}-${local.private}-${local.compute_instance}-${count.index+1}-vnic" : "${local.region}-${var.compute_spoke_name}-${local.private}-${local.compute_instance}-vnic"
        hostname_label = var.compute_spoke_private_num_nodes == 1 ? "${local.region}-${var.compute_spoke_name}-${local.private}-${local.compute_instance}-${count.index+1}" : "${local.region}-${var.compute_spoke_name}-${local.private}-${local.compute_instance}"
        subnet_id = var.deploy_network ? var.spoke_priv_sub_ocids[count.index%var.compute_spoke_private_num_nodes] : var.spoke_priv_sub_ocids[0]
    }
    display_name = var.compute_spoke_private_num_nodes == 1 ? "${local.region}-${var.compute_spoke_name}-${local.private}-${local.compute_instance}-${count.index+1}" : "${local.region}-${var.compute_spoke_name}-${local.private}-${local.compute_instance}"
    fault_domain = "FAULT-DOMAIN-${(count.index%3)+1}"
    dynamic shape_config {
        for_each = var.compute_spoke_private_shape == "VM.Standard.E3.Flex" ? [1] : []
        content {
        #Optional
        memory_in_gbs = var.compute_spoke_private_shape_config_memory_in_gbs
        ocpus = var.compute_spoke_private_shape_config_ocpus
        }
    }
    source_details {
        #Required
        source_id = var.compute_spoke_private_image_ocid
        source_type = "image"
        #Optional
        boot_volume_size_in_gbs = var.compute_spoke_private_boot_volume_size_in_gbs
        # kms_key_id = oci_kms_key.test_key.id
    }
    metadata = {
        ssh_authorized_keys = var.compute_spoke_private_ssh_public_key
    }
    preserve_boot_volume = false
}