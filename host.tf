data "vsphere_host_thumbprint" "thumbprint" {
  address  = var.host.hostaddress
  insecure = true
}

resource "vsphere_compute_cluster" "compute_cluster" {
  name                       = "esxi-cluster"
  datacenter_id              = vsphere_datacenter.datacenter.moid
  host_system_ids            = [vsphere_host.esxi.id]
  ha_enabled = false
  vsan_enabled = false
  vsan_dedup_enabled = false
  vsan_compression_enabled = false
  vsan_performance_enabled = false
  vsan_verbose_mode_enabled = false
  vsan_network_diagnostic_mode_enabled = false
  vsan_unmap_enabled = true
  vsan_dit_encryption_enabled = false
  #vsan_dit_rekey_interval = 1800
  #vsan_disk_group {
    #cache = data.vsphere_vmfs_disks.cache_disks[0]
    #storage = data.vsphere_vmfs_disks.storage_disks.disks
  #}
  depends_on = [vsphere_datacenter.datacenter]
}

resource "vsphere_host" "esxi" {
  hostname   = var.host.hostaddress
  username   = var.host.username
  password   = var.host.password
  thumbprint = data.vsphere_host_thumbprint.thumbprint.id
  license    = var.host.license
  datacenter = vsphere_datacenter.datacenter.moid
  #depends_on = [vsphere_compute_cluster.compute_cluster]
  lifecycle {
    ignore_changes = [cluster]
  }
}

data "vsphere_vmfs_disks" "storage_disks" {
  host_system_id = vsphere_host.esxi.id
  rescan         = true
  filter         = "t10.ATA"
}

#output "disks" {
#  value = data.vsphere_vmfs_disks.storage_disks.disks
#}
