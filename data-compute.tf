data "oci_core_subnet" "compute_hub_existing_subnet" {
    count = var.deploy_network ? 0 : 1
    #Required
    subnet_id = var.compute_hub_existing_subnet_ocid
}
data "oci_core_subnet" "compute_spoke_existing_subnet" {
    count = var.deploy_network ? 0 : 1
    #Required
    subnet_id = var.compute_spoke_existing_subnet_ocid
}