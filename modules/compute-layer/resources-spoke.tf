# TO DO:
# - conditions for deploy_network == false
# - generate and output the ssh keys for each compute.
# - cap the length of each custom name
# - output the public ips of each hub instance
# - create a host file of ips of all nodes on each hub instance
# - update schema.yml

# spoke compute
resource "oci_core_instance" "spoke_compute" {
    count = var.num_spoke_networks * (var.add_subnet["spoke"] ? 2 : 1) * var.compute_num_nodes["spoke"]
    #Required
    availability_domain = data.oci_identity_availability_domain.compute_spoke_availability_domain.name
    compartment_id = var.compute_compartment_ocid["spoke"]
    shape = var.compute_shape["spoke"]
    create_vnic_details {
        #Optional
        assign_public_ip = var.spoke_sub_are_private[count.index%(var.num_spoke_networks * (var.add_subnet["spoke"] ? 2 : 1))] ? false : true
        display_name = "${replace(replace(var.spoke_sub_display_names[count.index%(var.num_spoke_networks * (var.add_subnet["spoke"] ? 2 : 1))], var.network_name["spoke"], var.compute_name["spoke"]), local.subnet, local.compute_instance)}${var.compute_num_nodes["spoke"] > 1 ? format("-%s", floor(((count.index/(var.add_subnet["spoke"] ? 2 : 1))%var.compute_num_nodes["spoke"])+1)) : ""}-vnic"
        hostname_label = "${replace(replace(replace(replace(var.spoke_sub_display_names[count.index%(var.num_spoke_networks * (var.add_subnet["spoke"] ? 2 : 1))], var.network_name["spoke"], var.compute_name["spoke"]), local.subnet, local.compute_instance), "-", ""), local.region, "")}${var.compute_num_nodes["spoke"] > 1 ? format("-%s", floor(((count.index/(var.add_subnet["spoke"] ? 2 : 1))%var.compute_num_nodes["spoke"])+1)) : ""}"
        subnet_id = var.spoke_sub_ocids[count.index%(var.num_spoke_networks * (var.add_subnet["spoke"] ? 2 : 1))]
    }
    display_name = "${replace(replace(var.spoke_sub_display_names[count.index%(var.num_spoke_networks * (var.add_subnet["spoke"] ? 2 : 1))], var.network_name["spoke"], var.compute_name["spoke"]), local.subnet, local.compute_instance)}${var.compute_num_nodes["spoke"] > 1 ? format("-%s", floor(((count.index/(var.add_subnet["spoke"] ? 2 : 1))%var.compute_num_nodes["spoke"])+1)) : ""}"
    fault_domain = "FAULT-DOMAIN-${(count.index%3)+1}"
    dynamic shape_config {
        for_each = var.compute_shape["spoke"] == "VM.Standard.E3.Flex" ? [1] : []
        content {
        #Optional
        memory_in_gbs = var.compute_shape_config_memory_in_gbs["spoke"]
        ocpus = var.compute_shape_config_ocpus["spoke"]
        }
    }
    source_details {
        #Required
        source_id = var.compute_image_ocid["spoke"]
        source_type = "image"
        #Optional
        boot_volume_size_in_gbs = var.compute_boot_volume_size_in_gbs["spoke"]
        # kms_key_id = oci_kms_key.test_key.id
    }
    metadata = {
        ssh_authorized_keys = var.compute_ssh_key["spoke"]
    }
    preserve_boot_volume = false
}