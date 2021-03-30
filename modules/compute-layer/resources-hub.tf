# hub compute
resource "oci_core_instance" "hub_compute" {
    count = (var.add_subnet["hub"] ? 2 : 1) * var.compute_num_nodes["hub"]
    #Required
    availability_domain = data.oci_identity_availability_domain.compute_hub_availability_domain.name
    compartment_id = var.compute_compartment_ocid["hub"]
    shape = var.compute_shape["hub"]
    create_vnic_details {
        #Optional
        assign_public_ip = var.hub_sub_are_private[var.deploy_network ? count.index%(var.add_subnet["hub"] ? 2 : 1) : 0] ? false : true
        display_name = "${var.deploy_network ? replace(replace(replace(replace(var.hub_sub_display_names[count.index%(var.add_subnet["hub"] ? 2 : 1)], var.network_name["hub"], var.compute_name["hub"]), local.subnet, local.compute_instance), "/[^A-Za-z0-9]/", ""), local.region, "") : replace(var.hub_sub_display_names[0], "/[^A-Za-z0-9]/", "")}${var.compute_num_nodes["hub"] > 1 ? format("-%s", floor(count.index/(var.add_subnet["spoke"] ? 2 : 1))+1) : ""}-vnic"
        hostname_label = "${var.deploy_network ? replace(replace(replace(replace(var.hub_sub_display_names[count.index%(var.add_subnet["hub"] ? 2 : 1)], var.network_name["hub"], var.compute_name["hub"]), local.subnet, local.compute_instance), "/[^A-Za-z0-9]/", ""), local.region, "") : replace(var.hub_sub_display_names[0], "/[^A-Za-z0-9]/", "")}${var.compute_num_nodes["hub"] > 1 ? format("-%s", floor(count.index/(var.add_subnet["spoke"] ? 2 : 1))+1) : ""}"
        subnet_id = var.hub_sub_ocids[var.deploy_network ? count.index%(var.add_subnet["hub"] ? 2 : 1) : 0]
    }
    display_name = "${var.deploy_network ? replace(replace(replace(replace(var.hub_sub_display_names[count.index%(var.add_subnet["hub"] ? 2 : 1)], var.network_name["hub"], var.compute_name["hub"]), local.subnet, local.compute_instance), "/[^A-Za-z0-9]/", ""), local.region, "") : replace(var.hub_sub_display_names[0], "/[^A-Za-z0-9]/", "")}${var.compute_num_nodes["hub"] > 1 ? format("-%s", floor(count.index/(var.add_subnet["spoke"] ? 2 : 1))+1) : ""}"
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
    # metadata = {
    #     ssh_authorized_keys = var.compute_ssh_key["hub"]
    # }
    metadata = {
        ssh_authorized_keys = tls_private_key.hub_key[count.index].public_key_openssh
    }
    preserve_boot_volume = false
}
# private ssh key
resource "tls_private_key" "hub_key" {
    count = (var.add_subnet["hub"] ? 2 : 1) * var.compute_num_nodes["hub"]
    algorithm = "RSA"
}
# send private ssh keys to first hub compute
resource "null_resource" "hub_key" {
    depends_on = [null_resource.make_directory]
    count = (var.add_subnet["hub"] ? 2 : 1) * var.compute_num_nodes["hub"]
    provisioner "file" {
    content = tls_private_key.hub_key[count.index].private_key_pem
    destination = "${local.ssh_keys_dir_path}/${oci_core_instance.hub_compute[count.index].display_name}.pem"
    connection {
      host        = oci_core_instance.hub_compute[0].public_ip
      type        = "ssh"
      user        = "opc"
      private_key = tls_private_key.hub_key[0].private_key_pem
    }
  }
}
# hosts file gets deployed to hub computes
resource "null_resource" "host_file" {
    # depends_on = [oci_core_instance.hub_compute] # might be necessary for case when deployed to new network, then re-deployed with deploy_network == false to an existing subnet. This depends_on could make the difference between the hosts file being deployed vs. not to the new compute.
    count = (var.add_subnet["hub"] ? 2 : 1) * var.compute_num_nodes["hub"]
    provisioner "file" {
    content = templatefile("${path.module}/hosts.tpl", {
      spoke_displaynames_and_privateips = zipmap(local.spoke["display_names"], local.spoke["private_ips"])
      })
    destination = local.host_file_path
    connection {
      host        = oci_core_instance.hub_compute[count.index].public_ip
      type        = "ssh"
      user        = "opc"
      private_key = tls_private_key.hub_key[count.index].private_key_pem
    }
  }
}