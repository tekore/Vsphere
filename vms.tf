data "local_file" "vyos_cloud_init" {
  filename = "${path.module}/cloud-init/vyos.yaml"
  depends_on = [local_file.vyos_yaml]
}
data "local_file" "ubuntu_cloud_init" {
  filename = "${path.module}/cloud-init/ubuntu.yaml"
  depends_on = [local_file.ubuntu_yaml]
}
data "local_file" "rhel9_cloud_init" {
  filename = "${path.module}/cloud-init/user-data"
  depends_on = [local_file.rhel9_user_data]
}

resource "vsphere_virtual_machine" "vyos" {
  name               = "vyos"
  datastore_id       = data.vsphere_datastore.datastore.id
  host_system_id     = vsphere_host.esxi.id
  resource_pool_id   = vsphere_compute_cluster.compute_cluster.resource_pool_id
  firmware           = "efi"
  guest_id           = "debian10_64Guest"
  num_cpus           = 1
  memory             = 1024
  memory_reservation = 1024
  pci_device_id      = [var.host.pci-ethernet-mac]
  wait_for_guest_net_timeout = 0
  wait_for_guest_ip_timeout  = 0
  network_interface {
    network_id = data.vsphere_network.lab.id
  }
  disk {
    label            = "disk0"
    size             = 20
    thin_provisioned = true
  }
  clone {
    template_uuid = vsphere_content_library_item.content_vyos.id
  }
  vapp {
    properties  = {
      password  = var.host.password
      user-data = data.local_file.vyos_cloud_init.content_base64
    }
  }
  lifecycle {
    ignore_changes = [vapp[0].properties,]
  }
  replace_trigger = data.local_file.vyos_cloud_init.content_base64
  depends_on = [vsphere_content_library_item.content_vyos, data.local_file.vyos_cloud_init]
}

resource "vsphere_virtual_machine" "ubuntu" {
  name               = "ubuntu"
  datastore_id       = data.vsphere_datastore.datastore.id
  host_system_id     = vsphere_host.esxi.id
  resource_pool_id   = vsphere_compute_cluster.compute_cluster.resource_pool_id
  firmware           = "efi"
  guest_id           = "ubuntu64Guest"
  num_cpus           = 1
  memory             = 1024
  memory_reservation = 1024
  wait_for_guest_net_timeout = 0
  wait_for_guest_ip_timeout  = 0
  network_interface {
    network_id = data.vsphere_network.network.id
  }
  disk {
    label            = "disk0"
    size             = 120
    thin_provisioned = true
  }
  cdrom {
    client_device = true
  }
  clone {
    template_uuid = vsphere_content_library_item.content_ubuntu.id
  }
  vapp {
    properties  = {
      user-data = data.local_file.ubuntu_cloud_init.content_base64
    }
  }
  replace_trigger = data.local_file.ubuntu_cloud_init.content_base64
  depends_on = [vsphere_content_library_item.content_ubuntu, data.local_file.ubuntu_cloud_init]
}

resource "vsphere_virtual_machine" "rhel9" {
  name               = "rhel9"
  datastore_id       = data.vsphere_datastore.datastore.id
  host_system_id     = vsphere_host.esxi.id
  resource_pool_id   = vsphere_compute_cluster.compute_cluster.resource_pool_id
  firmware           = "efi"
  guest_id           = "other26xLinux64Guest"
  num_cpus           = 2
  memory             = 2048
  memory_reservation = 2048
  wait_for_guest_net_timeout = 0
  wait_for_guest_ip_timeout  = 0
  network_interface {
    network_id = data.vsphere_network.lab.id
  }
  cdrom {
    datastore_id = data.vsphere_datastore.datastore.id
    path         = "ISO/rhel9.iso"
  }
  disk {
    label            = "disk0"
    size             = 20
    thin_provisioned = true
  }
  clone {
    template_uuid = vsphere_content_library_item.content_rhel9.id
  }
  replace_trigger = data.local_file.rhel9_cloud_init.content_base64
  depends_on = [vsphere_content_library_item.content_rhel9, vsphere_file.rhel9_rhel9_cloud_init_upload]
}

#resource "vsphere_virtual_machine" "kubernetes_master" {
#  name                 = "kubernetes_master"
#  datastore_id         = data.vsphere_datastore.datastore.id
#  host_system_id       = vsphere_host.esxi.id
#  resource_pool_id     = vsphere_compute_cluster.compute_cluster.resource_pool_id
#  firmware             = "efi"
#  guest_id             = "other26xLinux64Guest"
#  num_cpus             = 2
#  memory               = 4096
#  memory_reservation   = 4096
#  wait_for_guest_net_timeout = 0
#  wait_for_guest_ip_timeout  = 0
#  network_interface {
#    network_id     = data.vsphere_network.lab.id
#    use_static_mac = true
#    mac_address    = var.static-macs.kubernetes-master
#  }
#  cdrom {
#    datastore_id = data.vsphere_datastore.datastore.id
#    path         = "ISO/rhel9.iso"
#  }
#  disk {
#    label            = "disk0"
#    size             = 20
#    thin_provisioned = true
#  }
#  clone {
#    template_uuid = vsphere_content_library_item.content_rhel9.id
#  }
#   replace_trigger = data.local_file.rhel9_cloud_init.content_base64
#  depends_on = [vsphere_content_library_item.content_rhel9, vsphere_file.rhel9_rhel9_cloud_init_upload]
#}
#
#resource "vsphere_virtual_machine" "kubernetes_worker" {
#  count                = var.worker-nodes-no
#  name                 = "kubernetes_worker${count.index}"
#  datastore_id         = data.vsphere_datastore.datastore.id
#  host_system_id       = vsphere_host.esxi.id
#  resource_pool_id     = vsphere_compute_cluster.compute_cluster.resource_pool_id
#  firmware             = "efi"
#  guest_id             = "other26xLinux64Guest"
#  num_cpus             = 2
#  memory               = 4096
#  memory_reservation   = 4096
#  wait_for_guest_net_timeout = 0
#  wait_for_guest_ip_timeout  = 0
#  network_interface {
#    network_id = data.vsphere_network.lab.id
#  }
#  cdrom {
#    datastore_id = data.vsphere_datastore.datastore.id
#    path         = "ISO/rhel9.iso"
#  }
#  disk {
#    label            = "disk0"
#    size             = 20
#    thin_provisioned = true
#  }
#  clone {
#    template_uuid = vsphere_content_library_item.content_rhel9.id
#  }
#  depends_on = [vsphere_content_library_item.content_rhel9, vsphere_file.rhel9_rhel9_cloud_init_upload]
#}
