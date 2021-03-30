# make directory before sending private ssh keys to directory
resource "null_resource" "make_directory" {
    count = var.compute_num_nodes["hub"] > 0 ? 1 : 0
    provisioner "remote-exec" {
        inline = [
          "mkdir -p ${local.ssh_keys_dir_path}",
        ]
    }
    connection {
      host        = oci_core_instance.hub_compute[0].public_ip
      type        = "ssh"
      user        = "opc"
      private_key = tls_private_key.hub_key[0].private_key_pem
    }
  }
# set permissions after sending private ssh keys to directory
resource "null_resource" "set_permissions" {
    depends_on = [null_resource.hub_key, null_resource.spoke_key]
    count = var.compute_num_nodes["hub"] > 0 ? 1 : 0
    provisioner "remote-exec" {
        inline = [
          "sudo chmod -R 777 ${local.ssh_keys_dir_path}",
        ]
    }
    connection {
      host        = oci_core_instance.hub_compute[0].public_ip
      type        = "ssh"
      user        = "opc"
      private_key = tls_private_key.hub_key[0].private_key_pem
    }
  }