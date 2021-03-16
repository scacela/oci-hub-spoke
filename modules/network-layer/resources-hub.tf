# vcn
resource "oci_core_vcn" "network_hub_vcn" {
  cidr_block = var.network_hub_cidr
  dns_label      = "${local.region}${var.network_hub_name}${local.virtual_cloud_network}"
  compartment_id = var.network_hub_compartment_ocid
  display_name   = "${local.region}-${var.network_hub_name}-${local.virtual_cloud_network}"
}
# lpg
resource "oci_core_local_peering_gateway" "network_hub_to_network_spoke_lpg" {
    count = var.num_spoke_networks
    compartment_id = var.network_hub_compartment_ocid
    vcn_id         = oci_core_vcn.network_hub_vcn.id
    display_name   = "${local.region}-${var.network_hub_name}-to-${var.network_spoke_name}-${count.index+1}-${local.local_peering_gateway}"
}
# rt for public subnet
resource "oci_core_route_table" "network_hub_pub_rt" {
  compartment_id = var.network_hub_compartment_ocid
  vcn_id         = oci_core_vcn.network_hub_vcn.id
  display_name   = "${local.region}-${var.network_hub_name}-${local.public}-${local.route_table}"
  # igw
  route_rules {
    network_entity_id = oci_core_internet_gateway.network_hub_igw.id
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
  }
  # lpg - local peering to spoke
  dynamic route_rules {
    for_each = range(var.num_spoke_networks)
    content { 
      network_entity_id = oci_core_local_peering_gateway.network_hub_to_network_spoke_lpg[route_rules.key].id
      destination       = oci_core_vcn.network_spoke_vcn[route_rules.key].cidr_blocks[0]
      destination_type  = "CIDR_BLOCK"
    }
  }
}
# rt for private subnet
resource "oci_core_route_table" "network_hub_priv_rt" {
  compartment_id  = var.network_hub_compartment_ocid
  vcn_id          = oci_core_vcn.network_hub_vcn.id
  display_name    = "${local.region}-${var.network_hub_name}-${local.private}-${local.route_table}"
  # ngw
  route_rules {
    network_entity_id = oci_core_nat_gateway.network_hub_ngw.id
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
  }
  # drg
  dynamic route_rules {
    for_each = var.network_hub_use_drg ? [1] : []
    content {
    network_entity_id = oci_core_drg.network_hub_drg[0].id
    destination       = var.network_client_premises_cidr
    destination_type  = "CIDR_BLOCK"
    }
  }
  # lpg - local peering to spoke
  dynamic route_rules {
    for_each = range(var.num_spoke_networks)
    content { 
      network_entity_id = oci_core_local_peering_gateway.network_hub_to_network_spoke_lpg[route_rules.key].id
      destination       = oci_core_vcn.network_spoke_vcn[route_rules.key].cidr_blocks[0]
      destination_type  = "CIDR_BLOCK"
    }
  }
}
# public subnet
resource "oci_core_subnet" "network_hub_pub_sub" {
  prohibit_public_ip_on_vnic = false
  cidr_block = cidrsubnet(oci_core_vcn.network_hub_vcn.cidr_blocks[0], log(var.network_hub_num_network_partitions, 2), 0)
  compartment_id    = var.network_hub_compartment_ocid
  vcn_id            = oci_core_vcn.network_hub_vcn.id
  display_name      = "${local.region}-${var.network_hub_name}-${local.public}-${local.subnet}"
  dns_label         = "${local.public}${local.subnet}"
  security_list_ids = [oci_core_security_list.network_hub_pub_sl.id]
  route_table_id    = oci_core_route_table.network_hub_pub_rt.id
}
# private subnet
resource "oci_core_subnet" "network_hub_priv_sub" {
  prohibit_public_ip_on_vnic = true
  cidr_block = cidrsubnet(oci_core_vcn.network_hub_vcn.cidr_blocks[0], log(var.network_hub_num_network_partitions, 2), 1)
  compartment_id    = var.network_hub_compartment_ocid
  vcn_id            = oci_core_vcn.network_hub_vcn.id
  display_name      = "${local.region}-${var.network_hub_name}-${local.private}-${local.subnet}"
  dns_label         = "${local.private}${local.subnet}"
  security_list_ids = [oci_core_security_list.network_hub_priv_sl.id]
  route_table_id    = oci_core_route_table.network_hub_priv_rt.id
}
#igw
resource "oci_core_internet_gateway" "network_hub_igw" {
  compartment_id = var.network_hub_compartment_ocid
  vcn_id         = oci_core_vcn.network_hub_vcn.id
  enabled        = true
  display_name   = "${local.region}-${var.network_hub_name}-${local.internet_gateway}"
}
# ngw
resource "oci_core_nat_gateway" "network_hub_ngw" {
  compartment_id = var.network_hub_compartment_ocid
  vcn_id         = oci_core_vcn.network_hub_vcn.id
  display_name   = "${local.region}-${var.network_hub_name}-${local.nat_gateway}"
  block_traffic  = false
}
# public sl
resource "oci_core_security_list" "network_hub_pub_sl" {
  compartment_id = var.network_hub_compartment_ocid
  vcn_id         = oci_core_vcn.network_hub_vcn.id
  display_name   = "${local.region}-${var.network_hub_name}-${local.public}-${local.security_list}"

  # outbound traffic
  egress_security_rules {
    destination      = "0.0.0.0/0"
    protocol         = "all"
  }
  # inbound traffic
  ingress_security_rules {
    protocol = 6
    source   = "0.0.0.0/0"

    tcp_options {
      max = 22
      min = 22
    }
  }
  ingress_security_rules {
    protocol = 1
    source   = "0.0.0.0/0"
    icmp_options {
      type = 8
    }
  }
}
# private sl
resource "oci_core_security_list" "network_hub_priv_sl" {
  compartment_id = var.network_hub_compartment_ocid
  vcn_id         = oci_core_vcn.network_hub_vcn.id
  display_name   = "${local.region}-${var.network_hub_name}-${local.private}-${local.security_list}"

  # outbound traffic
  egress_security_rules {
    destination      = "0.0.0.0/0"
    protocol         = "all"
  }
  # inbound traffic
  ingress_security_rules {
    protocol = 6
    source   = oci_core_subnet.network_hub_pub_sub.cidr_block

    tcp_options {
      max = 22
      min = 22
    }
  }
  ingress_security_rules {
    protocol = 1
    source   = oci_core_subnet.network_hub_pub_sub.cidr_block
    icmp_options {
      type = 8
    }
  }
}
# drg
resource "oci_core_drg" "network_hub_drg" {
  count = var.network_hub_use_drg ? 1 : 0
  compartment_id = var.network_hub_compartment_ocid
  display_name   = "${local.region}-${var.network_hub_name}-${local.dynamic_routing_gateway}"
}
resource "oci_core_drg_attachment" "network_hub_drg_attachment" {
  count = var.network_hub_use_drg ? 1 : 0
  #Required
  drg_id = oci_core_drg.network_hub_drg[0].id
  vcn_id = oci_core_vcn.network_hub_vcn.id

  #Optional
  display_name = "${local.region}-${var.network_hub_name}-${local.dynamic_routing_gateway}-attachment"
}
