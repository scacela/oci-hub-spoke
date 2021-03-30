# only used as auth variables
export TF_VAR_fingerprint=FINGERPRINT # replace
export TF_VAR_user_ocid=USER_OCID # replace
export TF_VAR_TF_VAR_private_key_path=~/.oci/oci_api_key.pem # example
# region
export TF_VAR_region=uk-london-1 # example
# tenancy
export TF_VAR_tenancy_ocid=TENANCY_OCID # replace
# compartments
export TF_VAR_network_hub_compartment_ocid=COMPARTMENT_OCID # replace
export TF_VAR_network_spoke_compartment_ocid=COMPARTMENT_OCID # replace
export TF_VAR_compute_hub_compartment_ocid=COMPARTMENT_OCID # replace
export TF_VAR_compute_spoke_compartment_ocid=COMPARTMENT_OCID # replace
# existing subnets (use actual values if you are deploying the compute-layer and not the network-layer)
export TF_VAR_compute_spoke_existing_subnet_ocid=SUBNET_OCID # replace
# Note: hub subnet should allow public ips
export TF_VAR_compute_hub_existing_subnet_ocid=SUBNET_OCID # replace