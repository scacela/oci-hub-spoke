variable "tenancy_ocid" {}
variable "region" {}
variable "deploy_network" { default = true }
variable "deploy_compute" { default = true }
variable "num_spoke_networks" { default = 3 }