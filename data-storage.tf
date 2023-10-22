data "vsphere_datastore" "datastore" {
  name          = var.data-storage.datastore
  datacenter_id = vsphere_datacenter.datacenter.moid
  depends_on    = [vsphere_host.esxi]
}

resource "vsphere_datacenter" "datacenter" {
  name = var.data-storage.datacenter
}

resource "vsphere_file" "rhel9_rhel9_cloud_init_upload" {
  datacenter         = vsphere_datacenter.datacenter.name 
  datastore          = data.vsphere_datastore.datastore.name
  source_file        = "${path.module}/cloud-init/rhel9.iso"
  destination_file   = "${path.module}/ISO/rhel9.iso"
  create_directories = true
  depends_on  = [vsphere_datacenter.datacenter]
}

resource "vsphere_content_library" "ova_library" {
  name            = "OVA Library"
  description     = "OVA Template Library"
  storage_backing = [data.vsphere_datastore.datastore.id]
}

resource "vsphere_content_library_item" "content_ubuntu" {
  name        = "UBUNTU"
  description = "UBUNTU OVA Template"
  file_url    = format("http://%s:8000/%s", var.server_ip, var.templates.ubuntu)
  library_id  = vsphere_content_library.ova_library.id
  depends_on  = [vsphere_content_library.ova_library]
}

resource "vsphere_content_library_item" "content_rhel9" {
  name        = "RHEL9"
  description = "RHEL9 OVA Template"
  file_url    = format("http://%s:8000/%s", var.server_ip, var.templates.rhel9)
  library_id  = vsphere_content_library.ova_library.id
  depends_on  = [vsphere_content_library.ova_library]
}

resource "vsphere_content_library_item" "content_vyos" {
  name        = "VYOS"
  description = "VYOS OVA Template"
  file_url    = format("http://%s:8000/%s", var.server_ip, var.templates.vyos)
  library_id  = vsphere_content_library.ova_library.id
  depends_on  = [vsphere_content_library.ova_library]
}

