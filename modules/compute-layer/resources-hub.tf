# hub pub compute
resource "oci_core_instance" "hub_pub_compute" {
    count = var.compute_hub_public_num_nodes
    #Required
    availability_domain = data.oci_identity_availability_domain.compute_hub_public_availability_domain.name
    compartment_id = var.compute_hub_public_compartment_ocid
    shape = var.compute_hub_public_shape
    create_vnic_details {
        #Optional
        assign_public_ip = true
        display_name = count.index > 1 ? "${local.region}-${var.compute_hub_name}-${local.public}-${local.compute_instance}-${count.index+1}-vnic" : "${local.region}-${var.compute_hub_name}-${local.public}-${local.compute_instance}-vnic"
        hostname_label = count.index > 1 ? "${local.region}-${var.compute_hub_name}-${local.public}-${local.compute_instance}-${count.index+1}" : "${local.region}-${var.compute_hub_name}-${local.public}-${local.compute_instance}"
        subnet_id = var.deploy_network ? var.hub_pub_sub_ocid : var.hub_pub_sub_ocid
        
    }
    display_name = count.index > 1 ? "${local.region}-${var.compute_hub_name}-${local.public}-${local.compute_instance}-${count.index+1}" : "${local.region}-${var.compute_hub_name}-${local.public}-${local.compute_instance}"
    fault_domain = "FAULT-DOMAIN-${(count.index%3)+1}"
    dynamic shape_config {
        for_each = var.compute_hub_public_shape == "VM.Standard.E3.Flex" ? [1] : []
        content {
        #Optional
        memory_in_gbs = var.compute_hub_public_shape_config_memory_in_gbs
        ocpus = var.compute_hub_public_shape_config_ocpus
        }
    }
    source_details {
        #Required
        source_id = var.compute_hub_public_image_ocid
        source_type = "image"
        #Optional
        boot_volume_size_in_gbs = var.compute_hub_public_boot_volume_size_in_gbs
        # kms_key_id = oci_kms_key.test_key.id
    }
    metadata = {
        ssh_authorized_keys = var.compute_hub_public_ssh_public_key
    }
    preserve_boot_volume = false
}
# hub priv compute
resource "oci_core_instance" "hub_priv_compute" {
    count = var.compute_hub_private_num_nodes
    #Required
    availability_domain = data.oci_identity_availability_domain.compute_hub_private_availability_domain.name
    compartment_id = var.compute_hub_private_compartment_ocid
    shape = var.compute_hub_private_shape
    create_vnic_details {
        #Optional
        assign_public_ip = false
        display_name = count.index > 1 ? "${local.region}-${var.compute_hub_name}-${local.private}-${local.compute_instance}-${count.index+1}-vnic" : "${local.region}-${var.compute_hub_name}-${local.private}-${local.compute_instance}-vnic"
        hostname_label = count.index > 1 ? "${local.region}-${var.compute_hub_name}-${local.private}-${local.compute_instance}-${count.index+1}" : "${local.region}-${var.compute_hub_name}-${local.private}-${local.compute_instance}"
        subnet_id = var.deploy_network ? var.hub_priv_sub_ocid : var.hub_priv_sub_ocid
        
    }
    display_name = count.index > 1 ? "${local.region}-${var.compute_hub_name}-${local.private}-${local.compute_instance}-${count.index+1}" : "${local.region}-${var.compute_hub_name}-${local.private}-${local.compute_instance}"
    fault_domain = "FAULT-DOMAIN-${(count.index%3)+1}"
    dynamic shape_config {
        for_each = var.compute_hub_private_shape == "VM.Standard.E3.Flex" ? [1] : []
        content {
        #Optional
        memory_in_gbs = var.compute_hub_private_shape_config_memory_in_gbs
        ocpus = var.compute_hub_private_shape_config_ocpus
        }
    }
    source_details {
        #Required
        source_id = var.compute_hub_private_image_ocid
        source_type = "image"
        #Optional
        boot_volume_size_in_gbs = var.compute_hub_private_boot_volume_size_in_gbs
        # kms_key_id = oci_kms_key.test_key.id
    }
    metadata = {
        ssh_authorized_keys = var.compute_hub_private_ssh_public_key
    }
    preserve_boot_volume = false
}