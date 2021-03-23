variable "tenancy_ocid" {}
variable "region" {}
variable "deploy_network" { default = true }
variable "deploy_compute" { default = true }
variable "num_spoke_networks" { default = 3 }

variable "add_subnet" {
  type = map(string)
  default = {
    hub = false
    spoke = true
  }
}
# subnet is public?
variable "subnet_is_public" {
  type = map(string)
  default = {
    # subnet a
    spoke_a = false
    # subnet b (if exists)
    hub_b = true
    spoke_b = false
  }
}