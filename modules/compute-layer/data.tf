data "oci_identity_regions" "available_regions" {
  filter {
    name = "name"
    values = [var.region]
    regex = false
  }
}
# hub pub ad
data "oci_identity_availability_domain" "compute_hub_public_availability_domain" {
  compartment_id = var.tenancy_ocid
  # ad_number      = regex(".$", var.compute_hub_public_availability_domain)
  ad_number      = var.compute_hub_public_availability_domain
}
# hub priv ad
data "oci_identity_availability_domain" "compute_hub_private_availability_domain" {
  compartment_id = var.tenancy_ocid
  # ad_number      = regex(".$", var.compute_hub_private_availability_domain)
  ad_number      = var.compute_hub_private_availability_domain
}
# spoke pub ad
data "oci_identity_availability_domain" "compute_spoke_public_availability_domain" {
  compartment_id = var.tenancy_ocid
  # ad_number      = regex(".$", var.compute_spoke_public_availability_domain)
  ad_number      = var.compute_spoke_public_availability_domain
}
# spoke priv ad
data "oci_identity_availability_domain" "compute_spoke_private_availability_domain" {
  compartment_id = var.tenancy_ocid
  # ad_number      = regex(".$", var.compute_spoke_private_availability_domain)
  ad_number      = var.compute_spoke_private_availability_domain
}