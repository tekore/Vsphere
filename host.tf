data "vsphere_host_thumbprint" "thumbprint" {
  address  = var.host.hostaddress
  insecure = true
}

resource "vsphere_compute_cluster" "compute_cluster" {
   name                       = "compute-cluster"
   datacenter_id              = vsphere_datacenter.datacenter.moid
   host_system_ids            = [vsphere_host.esxi.id]
}

resource "vsphere_host" "esxi" {
  hostname   = var.host.hostaddress
  username   = var.host.username
  password   = var.host.password
  thumbprint = data.vsphere_host_thumbprint.thumbprint.id
  license    = var.host.license
  datacenter = vsphere_datacenter.datacenter.moid
  depends_on = [vsphere_datacenter.datacenter]
  lifecycle {
    ignore_changes = [cluster]
  }
}
