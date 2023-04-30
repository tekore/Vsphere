data "vsphere_host_thumbprint" "thumbprint" {
  address  = var.host.hostaddress
  insecure = true
}

data "vsphere_host" "esxi" {
  name          = var.host.hostaddress
  datacenter_id = data.vsphere_datacenter.datacenter.id
  depends_on    = [vsphere_host.esxi]
}

resource "vsphere_host" "esxi" {
  hostname   = var.host.hostaddress
  username   = var.host.username
  password   = var.host.password
  thumbprint = data.vsphere_host_thumbprint.thumbprint.id
  license    = var.host.license
  datacenter = data.vsphere_datacenter.datacenter.id
}
