# vcn
resource "oci_core_vcn" "network_spoke_vcn" {
  count = var.num_spoke_networks
  cidr_blocks = [cidrsubnet(var.network_spoke_cidr_supernet, var.network_spoke_cidr_supernet_newbits, count.index)]
  dns_label = "${local.region}${var.network_spoke_name}${count.index}${local.virtual_cloud_network}"
  compartment_id = var.network_spoke_compartment_ocid
  display_name   = "${local.region}-${var.network_spoke_name}-${count.index+1}-${local.virtual_cloud_network}"
}
# lpg
resource "oci_core_local_peering_gateway" "network_spoke_to_network_hub_lpg" {
  count = var.num_spoke_networks
  compartment_id = var.network_spoke_compartment_ocid
  vcn_id = oci_core_vcn.network_spoke_vcn[count.index].id
  display_name = "${local.region}-${var.network_spoke_name}-${count.index+1}-to-${var.network_hub_name}-${local.local_peering_gateway}"
  peer_id = oci_core_local_peering_gateway.network_hub_to_network_spoke_lpg[count.index].id
}
# pub rt
resource "oci_core_route_table" "network_spoke_pub_rt" {
  count = var.num_spoke_networks
  compartment_id = var.network_spoke_compartment_ocid
  vcn_id = oci_core_vcn.network_spoke_vcn[count.index].id
  display_name = "${local.region}-${var.network_spoke_name}-${count.index+1}-${local.public}-${local.route_table}"
  # lpg (local peering to hub)
  route_rules {
    network_entity_id = oci_core_local_peering_gateway.network_spoke_to_network_hub_lpg[count.index].id
    destination       = var.network_hub_cidr
    destination_type  = "CIDR_BLOCK"
  }
  # ngw
  dynamic route_rules {
    for_each = var.network_spoke_use_ngw == true ? [1] : []
    content {
      network_entity_id = oci_core_nat_gateway.network_spoke_ngw[count.index].id
      destination       = "0.0.0.0/0"
      destination_type  = "CIDR_BLOCK"
    }
  }
  # sgw
  dynamic route_rules {
    for_each = var.network_spoke_use_sgw == true ? [1] : []
    content {
    network_entity_id = oci_core_service_gateway.network_spoke_sgw[count.index].id
    destination       = data.oci_core_services.available_services.services.0.cidr_block
    destination_type  = "SERVICE_CIDR_BLOCK"
    }
  }
}
# priv rt
resource "oci_core_route_table" "network_spoke_priv_rt" {
  count = var.num_spoke_networks
  compartment_id = var.network_spoke_compartment_ocid
  vcn_id = oci_core_vcn.network_spoke_vcn[count.index].id
  display_name = "${local.region}-${var.network_spoke_name}-${count.index+1}-${local.private}-${local.route_table}"
  # lpg (local peering to hub)
  route_rules {
    network_entity_id = oci_core_local_peering_gateway.network_spoke_to_network_hub_lpg[count.index].id
    destination       = var.network_hub_cidr
    destination_type  = "CIDR_BLOCK"
  }
  # ngw
  dynamic route_rules {
    for_each = var.network_spoke_use_ngw == true ? [1] : []
    content {
      network_entity_id = oci_core_nat_gateway.network_spoke_ngw[count.index].id
      destination       = "0.0.0.0/0"
      destination_type  = "CIDR_BLOCK"
    }
  }
  # sgw
  dynamic route_rules {
    for_each = var.network_spoke_use_sgw == true ? [1] : []
    content {
    network_entity_id = oci_core_service_gateway.network_spoke_sgw[count.index].id
    destination       = data.oci_core_services.available_services.services.0.cidr_block
    destination_type  = "SERVICE_CIDR_BLOCK"
    }
  }
}
# public sub
resource "oci_core_subnet" "network_spoke_pub_sub" {
  count = var.num_spoke_networks
  prohibit_public_ip_on_vnic = false
  # cidrsubnet(prefix (i.e. the subnet's parent cidr range), newbits (i.e. unmask space for newbits subnets), netnum (i.e. specify one of the resulting cidr ranges by index netnum))
  cidr_block = cidrsubnet(oci_core_vcn.network_spoke_vcn[count.index].cidr_blocks[0], log(var.network_spoke_num_network_partitions, 2), 0)
  compartment_id = var.network_spoke_compartment_ocid
  vcn_id = oci_core_vcn.network_spoke_vcn[count.index].id
  display_name = "${local.region}-${var.network_spoke_name}-${count.index+1}-${local.public}-${local.subnet}"
  dns_label = "${local.public}${local.subnet}"
  security_list_ids = [oci_core_security_list.network_spoke_pub_sl[count.index].id]
  route_table_id = oci_core_route_table.network_spoke_pub_rt[count.index].id
}
# private sub
resource "oci_core_subnet" "network_spoke_priv_sub" {
  count = var.num_spoke_networks
  prohibit_public_ip_on_vnic = true
  cidr_block = cidrsubnet(oci_core_vcn.network_spoke_vcn[count.index].cidr_blocks[0], log(var.network_spoke_num_network_partitions, 2), 1)
  compartment_id = var.network_spoke_compartment_ocid
  vcn_id = oci_core_vcn.network_spoke_vcn[count.index].id
  display_name = "${local.region}-${var.network_spoke_name}-${count.index+1}-${local.private}-${local.subnet}"
  dns_label = "${local.private}${local.subnet}"
  security_list_ids = [oci_core_security_list.network_spoke_priv_sl[count.index].id]
  route_table_id = oci_core_route_table.network_spoke_priv_rt[count.index].id
}
# ngw
resource "oci_core_nat_gateway" "network_spoke_ngw" {
  count = var.num_spoke_networks * (var.network_spoke_use_ngw == true ? 1 : 0)
  compartment_id = var.network_spoke_compartment_ocid
  vcn_id = oci_core_vcn.network_spoke_vcn[count.index].id
  display_name   = "${local.region}-${var.network_spoke_name}-${count.index+1}-${local.nat_gateway}"
  block_traffic = false
}
# sgw
resource "oci_core_service_gateway" "network_spoke_sgw" {
  count = var.num_spoke_networks * (var.network_spoke_use_sgw == true ? 1 : 0)
  #Required
  compartment_id = var.network_spoke_compartment_ocid
  services {
    service_id = data.oci_core_services.available_services.services[0]["id"]
  }
  vcn_id = oci_core_vcn.network_spoke_vcn[count.index].id
  #Optional
  display_name = "${local.region}-${var.network_spoke_name}-${count.index+1}-${local.service_gateway}"
}
# public sl
resource "oci_core_security_list" "network_spoke_pub_sl" {
  count = var.num_spoke_networks
  compartment_id = var.network_spoke_compartment_ocid
  vcn_id         = oci_core_vcn.network_spoke_vcn[count.index].id
  display_name   = "${local.region}-${var.network_spoke_name}-${count.index+1}-${local.public}-${local.security_list}"

  # outbound traffic
  egress_security_rules {
    destination      = "0.0.0.0/0"
    protocol         = "all"
  }
  # inbound traffic
  ingress_security_rules {
    protocol = 6
    source   = var.network_hub_cidr

    tcp_options {
      max = 22
      min = 22
    }
  }
  ingress_security_rules {
    protocol = 1
    source   = var.network_hub_cidr
    icmp_options {
      type = 8
    }
  }
}
# private sl
resource "oci_core_security_list" "network_spoke_priv_sl" {
  count = var.num_spoke_networks
  compartment_id = var.network_spoke_compartment_ocid
  vcn_id         = oci_core_vcn.network_spoke_vcn[count.index].id
  display_name   = "${local.region}-${var.network_spoke_name}-${count.index+1}-${local.private}-${local.security_list}"

  # outbound traffic
  egress_security_rules {
    destination      = "0.0.0.0/0"
    protocol         = "all"
  }
  # inbound traffic
  ingress_security_rules {
    protocol = 6
    source   = oci_core_subnet.network_spoke_pub_sub[count.index].cidr_block

    tcp_options {
      max = 22
      min = 22
    }
  }
  ingress_security_rules {
    protocol = 1
    source   = oci_core_subnet.network_spoke_pub_sub[count.index].cidr_block
    icmp_options {
      type = 8
    }
  }
}
