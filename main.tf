terraform {
  required_providers {
    vsphere = {
      source = "hashicorp/vsphere"
    }
  }
}

provider "vsphere" {
    user                 = var.vcenter.username
    password             = var.vcenter.password
    vsphere_server       = var.vcenter.hostaddress
    allow_unverified_ssl = true
}
