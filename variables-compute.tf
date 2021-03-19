# Solaris 11.4 (global)
  # vm
  # ocid1.image.oc1..aaaaaaaatmfegrt4uzjgmcemh3vrk46f7ileqcfohhas56hi3pnjhp4nfhoq
  # bm
  # ocid1.image.oc1..aaaaaaaaox5drc6ocosbq7a7jh7beqlvghojoi4b6gjgul26c7jkmizi5a3a
# CentOS-8-2021.02.26-0 (uk-london-1)
  # ocid1.image.oc1.uk-london-1.aaaaaaaakpa2zlibtjh5nrpaewb75k7pl3cy6oibq3hz7psm26uuiok56sfa

# hub variables
variable "compute_hub_name" { default = "hub" }
  # public
variable "compute_hub_public_availability_domain" { default = 1 }
variable "compute_hub_public_compartment_ocid" { default = "" }
variable "compute_hub_public_shape" { default = "VM.Standard2.1" }
variable "compute_hub_public_shape_config_memory_in_gbs" { default = 16 } # used if shape is flex shape
variable "compute_hub_public_shape_config_ocpus" { default = 1 } # used if shape is flex shape
variable "compute_hub_public_image_ocid" { default = "ocid1.image.oc1..aaaaaaaatmfegrt4uzjgmcemh3vrk46f7ileqcfohhas56hi3pnjhp4nfhoq" }
variable "compute_hub_public_boot_volume_size_in_gbs" { default = 64 }
variable "compute_hub_public_existing_subnet_ocid" { default = "" } # used if deploy network false
variable "compute_hub_public_num_nodes" { default = 1 }
variable "compute_hub_public_ssh_public_key" { default = "" }
  # private
variable "compute_hub_private_availability_domain" { default = 1 }
variable "compute_hub_private_compartment_ocid" { default = "" }
variable "compute_hub_private_shape" { default = "VM.Standard2.1" }
variable "compute_hub_private_shape_config_memory_in_gbs" { default = 16 } # used if shape is flex shape
variable "compute_hub_private_shape_config_ocpus" { default = 1 } # used if shape is flex shape
variable "compute_hub_private_image_ocid" { default = "ocid1.image.oc1..aaaaaaaatmfegrt4uzjgmcemh3vrk46f7ileqcfohhas56hi3pnjhp4nfhoq" }
variable "compute_hub_private_boot_volume_size_in_gbs" { default = 64 }
variable "compute_hub_private_existing_subnet_ocid" { default = "" } # used if deploy network false
variable "compute_hub_private_num_nodes" { default = 1 }
variable "compute_hub_private_ssh_public_key" { default = "" }
# spoke variables
variable "compute_spoke_name" { default = "student" }
  # public
variable "compute_spoke_public_availability_domain" { default = 1 }
variable "compute_spoke_public_compartment_ocid" {}
variable "compute_spoke_public_shape" { default = "VM.Standard2.1" }
variable "compute_spoke_public_shape_config_memory_in_gbs" { default = 16 } # used if shape is flex shape
variable "compute_spoke_public_shape_config_ocpus" { default = 1 } # used if shape is flex shape
variable "compute_spoke_public_image_ocid" { default = "ocid1.image.oc1..aaaaaaaatmfegrt4uzjgmcemh3vrk46f7ileqcfohhas56hi3pnjhp4nfhoq" }
variable "compute_spoke_public_boot_volume_size_in_gbs" { default = 64 }
variable "compute_spoke_public_existing_subnet_ocid" { default = "" } # used if deploy network false
variable "compute_spoke_public_num_nodes" { default = 1 }
variable "compute_spoke_public_ssh_public_key" { default = "" }
  # private
variable "compute_spoke_private_availability_domain" { default = 1 }
variable "compute_spoke_private_compartment_ocid" {}
variable "compute_spoke_private_shape" { default = "VM.Standard.E3.Flex" }
variable "compute_spoke_private_shape_config_memory_in_gbs" { default = 16 } # used if shape is flex shape
variable "compute_spoke_private_shape_config_ocpus" { default = 1 } # used if shape is flex shape
variable "compute_spoke_private_image_ocid" { default = "ocid1.image.oc1..aaaaaaaatmfegrt4uzjgmcemh3vrk46f7ileqcfohhas56hi3pnjhp4nfhoq" }
variable "compute_spoke_private_boot_volume_size_in_gbs" { default = 64 }
variable "compute_spoke_private_existing_subnet_ocid" { default = "" } # used if deploy network false
variable "compute_spoke_private_num_nodes" { default = 1 }
variable "compute_spoke_private_ssh_public_key" { default = "" }