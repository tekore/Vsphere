data "vsphere_datacenter" "datacenter" {
  name       = var.data-storage.datacenter
  depends_on = [vsphere_datacenter.datacenter]
}

data "vsphere_datastore" "datastore" {
  name          = var.data-storage.datastore
  datacenter_id = data.vsphere_datacenter.datacenter.id
  depends_on    = [vsphere_host.esxi]
}

data "vsphere_content_library" "ovf_library" {
  name = "OVF Library"
  depends_on = [vsphere_content_library.ovf_library]
}

data "vsphere_content_library" "iso_library" {
  name = "ISO Library"
  depends_on = [vsphere_content_library.iso_library]
}

data "vsphere_content_library_item" "content_rhel9" {
  name       = "rhel9"
  library_id = vsphere_content_library.ovf_library.id
  type       = "template"
  depends_on = [vsphere_content_library_item.content_rhel9]
}

data "vsphere_content_library_item" "content_vyos" {
  name       = "vyos"
  library_id = vsphere_content_library.ovf_library.id
  type       = "OVF"
  depends_on = [vsphere_content_library_item.content_vyos]
}

data "vsphere_content_library_item" "content_truenas" {
  name       = "truenas"
  library_id = vsphere_content_library.ovf_library.id
  type       = "OVF"
  depends_on = [vsphere_content_library_item.content_truenas]
}

resource "vsphere_datacenter" "datacenter" {
  name = var.data-storage.datacenter
}

resource "vsphere_content_library" "ovf_library" {
  name            = "OVF Library"
  description     = "OVF Template Library"
  storage_backing = [data.vsphere_datastore.datastore.id]
}

resource "vsphere_content_library" "iso_library" {
  name            = "ISO Library"
  description     = "ISO Library"
  storage_backing = [data.vsphere_datastore.datastore.id]
}

resource "vsphere_content_library_item" "content_rhel9" {
  name        = "RHEL9"
  description = "RHEL9 OVA Template"
  file_url    = format("http://%s:8000/%s", var.server_ip, var.templates.rhel9)
  library_id  = data.vsphere_content_library.ovf_library.id
  depends_on  = [vsphere_content_library.ovf_library]
}

resource "vsphere_content_library_item" "content_vyos" {
  name        = "VYOS"
  description = "VYOS OVA Template"
  file_url    = format("http://%s:8000/%s", var.server_ip, var.templates.vyos)
  library_id  = data.vsphere_content_library.ovf_library.id
  depends_on  = [vsphere_content_library.ovf_library]
}

resource "vsphere_content_library_item" "content_truenas" {
  name        = "TRUENAS"
  description = "TRUENAS OVA Template"
  file_url    = format("http://%s:8000/%s", var.server_ip, var.templates.truenas)
  library_id  = data.vsphere_content_library.ovf_library.id
  depends_on  = [vsphere_content_library.ovf_library]
}

