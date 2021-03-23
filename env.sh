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
# ssh public keys
export TF_VAR_compute_spoke_ssh_key=$(cat ~/.ssh/id_rsa.pub) # example
export TF_VAR_compute_hub_ssh_key=$(cat ~/.ssh/id_rsa.pub) # example