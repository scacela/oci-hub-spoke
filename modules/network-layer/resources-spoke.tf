# vcn
resource "oci_core_vcn" "network_spoke_vcn" {
  count = var.num_spoke_networks
  cidr_blocks = [cidrsubnet(var.network_spoke_cidr_supernet, var.network_spoke_cidr_supernet_newbits, count.index)]
  dns_label = "${local.region}${var.network_name["spoke"]}${count.index}${local.virtual_cloud_network}"
  compartment_id = var.network_compartment_ocid["spoke"]
  display_name   = "${local.region}-${var.network_name["spoke"]}-${count.index+1}-${local.virtual_cloud_network}"
}
# lpg
resource "oci_core_local_peering_gateway" "network_spoke_to_network_hub_lpg" {
  count = var.num_spoke_networks
  compartment_id = var.network_compartment_ocid["spoke"]
  vcn_id = oci_core_vcn.network_spoke_vcn[count.index].id
  display_name = "${local.region}-${var.network_name["spoke"]}-${count.index+1}-to-${var.network_name["hub"]}-${local.local_peering_gateway}"
  peer_id = oci_core_local_peering_gateway.network_hub_to_network_spoke_lpg[count.index].id
}

# rt
resource "oci_core_route_table" "network_spoke_rt" {
  count =  var.num_spoke_networks * (var.add_subnet["spoke"] ? 2 : 1)
  compartment_id = var.network_compartment_ocid["spoke"]
  vcn_id = oci_core_vcn.network_spoke_vcn[floor(count.index/(var.add_subnet["spoke"] ? 2 : 1))].id
  # display_name format: REGIONKEY-NETWORKNAME-A/B/EMPTY-PUBLIC/PRIVATE-RESOURCENAME
  display_name = "${local.region}-${var.network_name["spoke"]}-${(var.add_subnet["spoke"] ? (count.index%2 == 0 ? "a" : "b") : "")}-${(var.add_subnet["spoke"] ? ((count.index%2 == 0 && var.subnet_is_public["spoke_a"]) || (count.index%2 == 1 && var.subnet_is_public["spoke_b"]) ? local.public : local.private) : (var.subnet_is_public["spoke_a"] ? local.public : local.private))}-${local.route_table}"
  # lpg (local peering to hub)
  route_rules {
    network_entity_id = oci_core_local_peering_gateway.network_spoke_to_network_hub_lpg[floor(count.index/(var.add_subnet["spoke"] ? 2 : 1))].id
    destination       = var.network_hub_cidr
    destination_type  = "CIDR_BLOCK"
  }
  # ngw
  dynamic route_rules {
    for_each = var.network_use_ngw["spoke"] == true ? [1] : []
    content {
      network_entity_id = oci_core_nat_gateway.network_spoke_ngw[floor(count.index/(var.add_subnet["spoke"] ? 2 : 1))].id
      destination       = "0.0.0.0/0"
      destination_type  = "CIDR_BLOCK"
    }
  }
  # sgw
  dynamic route_rules {
    for_each = var.network_spoke_use_sgw == true ? [1] : []
    content {
    network_entity_id = oci_core_service_gateway.network_spoke_sgw[floor(count.index/(var.add_subnet["spoke"] ? 2 : 1))].id
    destination       = data.oci_core_services.available_services.services.0.cidr_block
    destination_type  = "SERVICE_CIDR_BLOCK"
    }
  }
}
# sub
resource "oci_core_subnet" "network_spoke_sub" {
  count =  var.num_spoke_networks * (var.add_subnet["spoke"] ? 2 : 1)
  prohibit_public_ip_on_vnic = (count.index == 0 && var.subnet_is_public["spoke_a"]) || (count.index == 0 && var.subnet_is_public["spoke_b"]) ? false : true
  # cidrsubnet(prefix (i.e. the subnet's parent cidr range), newbits (i.e. unmask space for newbits subnets), netnum (i.e. specify one of the resulting cidr ranges by index netnum))
  cidr_block = cidrsubnet(oci_core_vcn.network_spoke_vcn[floor(count.index/(var.add_subnet["spoke"] ? 2 : 1))].cidr_blocks[0], log(var.network_num_network_partitions["spoke"], 2), (count.index%(var.add_subnet["spoke"] ? 2 : 1)))
  compartment_id = var.network_compartment_ocid["spoke"]
  vcn_id = oci_core_vcn.network_spoke_vcn[floor(count.index/(var.add_subnet["spoke"] ? 2 : 1))].id
  display_name = "${local.region}-${var.network_name["spoke"]}-${floor(count.index/(var.add_subnet["spoke"] ? 2 : 1))+1}-${(var.add_subnet["spoke"] ? (count.index%2 == 0 ? "a-" : "b-") : "")}${(var.add_subnet["spoke"] ? ((count.index%2 == 0 && var.subnet_is_public["spoke_a"]) || (count.index%2 == 1 && var.subnet_is_public["spoke_b"]) ? local.public : local.private) : (var.subnet_is_public["spoke_a"] ? local.public : local.private))}-${local.subnet}"
  dns_label = "${var.network_name["spoke"]}${floor(count.index/(var.add_subnet["spoke"] ? 2 : 1))+1}${(var.add_subnet["spoke"] ? (count.index%2 == 0 ? "a" : "b") : "")}${(var.add_subnet["spoke"] ? ((count.index%2 == 0 && var.subnet_is_public["spoke_a"]) || (count.index%2 == 1 && var.subnet_is_public["spoke_b"]) ? local.public : local.private) : (var.subnet_is_public["spoke_a"] ? local.public : local.private))}"
  security_list_ids = [oci_core_security_list.network_spoke_sl[count.index].id]
  route_table_id = oci_core_route_table.network_spoke_rt[count.index].id
}

# ngw
resource "oci_core_nat_gateway" "network_spoke_ngw" {
  count = var.num_spoke_networks * (var.network_use_ngw["spoke"] ? 1 : 0)
  compartment_id = var.network_compartment_ocid["spoke"]
  vcn_id = oci_core_vcn.network_spoke_vcn[count.index].id
  display_name   = "${local.region}-${var.network_name["spoke"]}-${(count.index%var.num_spoke_networks)+1}-${local.nat_gateway}"
  block_traffic = false
}
# sgw
resource "oci_core_service_gateway" "network_spoke_sgw" {
  count = var.num_spoke_networks * (var.network_spoke_use_sgw ? 1 : 0)
  #Required
  compartment_id = var.network_compartment_ocid["spoke"]
  services {
    service_id = data.oci_core_services.available_services.services[0]["id"]
  }
  vcn_id = oci_core_vcn.network_spoke_vcn[count.index].id
  #Optional
  display_name = "${local.region}-${var.network_name["spoke"]}-${(count.index%var.num_spoke_networks)+1}-${local.service_gateway}"
}

# sl
resource "oci_core_security_list" "network_spoke_sl" {
  count =  var.num_spoke_networks * (var.add_subnet["spoke"] ? 2 : 1)
  compartment_id = var.network_compartment_ocid["spoke"]
  vcn_id = oci_core_vcn.network_spoke_vcn[floor(count.index/(var.add_subnet["spoke"] ? 2 : 1))].id
  display_name   = "${local.region}-${var.network_name["spoke"]}-${(var.add_subnet["spoke"] ? (count.index%2 == 0 ? "a" : "b") : "")}-${(var.add_subnet["spoke"] ? ((count.index%2 == 0 && var.subnet_is_public["spoke_a"]) || (count.index%2 == 1 && var.subnet_is_public["spoke_b"]) ? local.public : local.private) : (var.subnet_is_public["spoke_a"] ? local.public : local.private))}-${local.security_list}"

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