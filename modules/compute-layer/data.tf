data "oci_identity_regions" "available_regions" {
  filter {
    name = "name"
    values = [var.region]
    regex = false
  }
}
# hub pub ad
data "oci_identity_availability_domain" "compute_hub_availability_domain" {
  compartment_id = var.tenancy_ocid
  ad_number      = var.compute_availability_domain["hub"]
}

# spoke pub ad
data "oci_identity_availability_domain" "compute_spoke_availability_domain" {
  compartment_id = var.tenancy_ocid
  ad_number      = var.compute_availability_domain["spoke"]
}