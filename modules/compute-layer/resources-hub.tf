# hub compute
resource "oci_core_instance" "hub_compute" {
    count = (var.add_subnet["hub"] ? 2 : 1) * var.compute_num_nodes["hub"]
    #Required
    availability_domain = data.oci_identity_availability_domain.compute_hub_availability_domain.name
    compartment_id = var.compute_compartment_ocid["hub"]
    shape = var.compute_shape["hub"]
    create_vnic_details {
        #Optional
        assign_public_ip = var.hub_sub_are_private[count.index%(var.add_subnet["hub"] ? 2 : 1)] ? false : true
        display_name = "${replace(replace(var.hub_sub_display_names[count.index%(var.add_subnet["hub"] ? 2 : 1)], var.network_name["hub"], var.compute_name["hub"]), local.subnet, local.compute_instance)}${var.compute_num_nodes["hub"] > 1 ? format("-%s", floor(((count.index/(var.add_subnet["hub"] ? 2 : 1))%var.compute_num_nodes["hub"])+1)) : ""}-vnic"
        hostname_label = "${replace(replace(replace(replace(var.hub_sub_display_names[count.index%(var.add_subnet["hub"] ? 2 : 1)], var.network_name["hub"], var.compute_name["hub"]), local.subnet, local.compute_instance), "-", ""), local.region, "")}${var.compute_num_nodes["hub"] > 1 ? format("-%s", floor(((count.index/(var.add_subnet["hub"] ? 2 : 1))%var.compute_num_nodes["hub"])+1)) : ""}"
        # all compute instances are assigned to subnet a
        subnet_id = var.hub_sub_ocids[count.index%(var.add_subnet["hub"] ? 2 : 1)]
    }
    display_name = "${replace(replace(var.hub_sub_display_names[count.index%(var.add_subnet["hub"] ? 2 : 1)], var.network_name["hub"], var.compute_name["hub"]), local.subnet, local.compute_instance)}${var.compute_num_nodes["hub"] > 1 ? format("-%s", floor(((count.index/(var.add_subnet["hub"] ? 2 : 1))%var.compute_num_nodes["hub"])+1)) : ""}"
    fault_domain = "FAULT-DOMAIN-${(count.index%3)+1}"
    dynamic shape_config {
        for_each = var.compute_shape["hub"] == "VM.Standard.E3.Flex" ? [1] : []
        content {
        #Optional
        memory_in_gbs = var.compute_shape_config_memory_in_gbs["hub"]
        ocpus = var.compute_shape_config_ocpus["hub"]
        }
    }
    source_details {
        #Required
        source_id = var.compute_image_ocid["hub"]
        source_type = "image"
        #Optional
        boot_volume_size_in_gbs = var.compute_boot_volume_size_in_gbs["hub"]
        # kms_key_id = oci_kms_key.test_key.id
    }
    metadata = {
        ssh_authorized_keys = var.compute_ssh_key["hub"]
    }
    preserve_boot_volume = false
}