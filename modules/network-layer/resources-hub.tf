# vcn
resource "oci_core_vcn" "network_hub_vcn" {
  cidr_block = var.network_hub_cidr
  dns_label      = "${local.region}${var.network_name["hub"]}${local.virtual_cloud_network}"
  compartment_id = var.network_compartment_ocid["hub"]
  display_name   = "${local.region}-${var.network_name["hub"]}-${local.virtual_cloud_network}"
}
# lpg
resource "oci_core_local_peering_gateway" "network_hub_to_network_spoke_lpg" {
  count = var.num_spoke_networks
  compartment_id = var.network_compartment_ocid["hub"]
  vcn_id         = oci_core_vcn.network_hub_vcn.id
  display_name   = "${local.region}-${var.network_name["hub"]}-to-${var.network_name["spoke"]}-${count.index+1}-${local.local_peering_gateway}"
}
# rt
resource "oci_core_route_table" "network_hub_rt" {
  count = var.add_subnet["hub"] ? 2 : 1
  compartment_id = var.network_compartment_ocid["hub"]
  vcn_id         = oci_core_vcn.network_hub_vcn.id
  display_name   = "${local.region}-${var.network_name["hub"]}-${count.index == 0 || var.subnet_is_public["hub_b"] ? local.public : local.private}-${local.route_table}"
  # igw
  dynamic route_rules {
    for_each = count.index == 0 || var.subnet_is_public["hub_b"] ? [1] : []
    content {
    network_entity_id = oci_core_internet_gateway.network_hub_igw.id
    destination       = "0.0.0.0/0"
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
  # ngw
  dynamic route_rules {
    for_each = (count.index == 0 || var.subnet_is_public["hub_b"]) && var.network_use_ngw["hub"] ? [] : [1]
    content {
      network_entity_id = oci_core_nat_gateway.network_hub_ngw[count.index%(var.add_subnet["hub"] ? 2 : 1)].id
      destination       = "0.0.0.0/0"
      destination_type  = "CIDR_BLOCK"
    }
  }
}
# sub
resource "oci_core_subnet" "network_hub_sub" {
  count = var.add_subnet["hub"] ? 2 : 1
  prohibit_public_ip_on_vnic = count.index == 0 || var.subnet_is_public["hub_b"] ? false : true
  cidr_block = cidrsubnet(oci_core_vcn.network_hub_vcn.cidr_blocks[0], log(var.network_num_network_partitions["hub"], 2), count.index)
  compartment_id    = var.network_compartment_ocid["hub"]
  vcn_id            = oci_core_vcn.network_hub_vcn.id
  display_name = "${local.region}-${var.network_name["hub"]}-${(var.add_subnet["hub"] ? (count.index%2 == 0 ? "a-" : "b-") : "")}${count.index == 0 || var.subnet_is_public["hub_b"] ? local.public : local.private}-${local.subnet}"
  dns_label = "${var.network_name["hub"]}${(var.add_subnet["hub"] ? (count.index%2 == 0 ? "a" : "b") : "")}${count.index == 0 || var.subnet_is_public["hub_b"] ? local.public : local.private}"
  security_list_ids = [oci_core_security_list.network_hub_sl[count.index].id]
  route_table_id    = oci_core_route_table.network_hub_rt[count.index].id
}
#igw
resource "oci_core_internet_gateway" "network_hub_igw" {
  compartment_id = var.network_compartment_ocid["hub"]
  vcn_id         = oci_core_vcn.network_hub_vcn.id
  enabled        = true
  display_name   = "${local.region}-${var.network_name["hub"]}-${local.internet_gateway}"
}
# ngw
resource "oci_core_nat_gateway" "network_hub_ngw" {
  count = var.network_use_ngw["hub"] ? 1 : 0
  compartment_id = var.network_compartment_ocid["hub"]
  vcn_id         = oci_core_vcn.network_hub_vcn.id
  display_name   = "${local.region}-${var.network_name["hub"]}-${local.nat_gateway}"
  block_traffic  = false
}
# sl
resource "oci_core_security_list" "network_hub_sl" {
  count = var.add_subnet["hub"] ? 2 : 1
  compartment_id = var.network_compartment_ocid["hub"]
  vcn_id         = oci_core_vcn.network_hub_vcn.id
  display_name   = "${local.region}-${var.network_name["hub"]}-${count.index == 0 || var.subnet_is_public["hub_b"] ? local.public : local.private}-${local.security_list}"

  # outbound traffic
  egress_security_rules {
    destination      = "0.0.0.0/0"
    protocol         = "all"
  }
  # inbound traffic
  ingress_security_rules {
    protocol = 6
    source   = count.index == 0 || var.subnet_is_public["hub_b"] ? "0.0.0.0/0" : var.network_client_premises_cidr

    tcp_options {
      max = 22
      min = 22
    }
  }
  ingress_security_rules {
    protocol = 1
    source   = count.index == 0 || var.subnet_is_public["hub_b"] ? "0.0.0.0/0" : var.network_client_premises_cidr
    icmp_options {
      type = 8
    }
  }
}
# drg
resource "oci_core_drg" "network_hub_drg" {
  count = var.network_hub_use_drg ? 1 : 0
  compartment_id = var.network_compartment_ocid["hub"]
  display_name   = "${local.region}-${var.network_name["hub"]}-${local.dynamic_routing_gateway}"
}
resource "oci_core_drg_attachment" "network_hub_drg_attachment" {
  count = var.network_hub_use_drg ? 1 : 0
  #Required
  drg_id = oci_core_drg.network_hub_drg[0].id
  vcn_id = oci_core_vcn.network_hub_vcn.id

  #Optional
  display_name = "${local.region}-${var.network_name["hub"]}-${local.dynamic_routing_gateway}-attachment"
}