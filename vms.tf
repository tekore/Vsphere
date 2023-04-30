resource "vsphere_virtual_machine" "vyos" {
  name               = "vyos"
  resource_pool_id   = data.vsphere_host.esxi.resource_pool_id
  datastore_id       = data.vsphere_datastore.datastore.id
  host_system_id     = data.vsphere_host.esxi.id
  num_cpus           = 1
  memory             = 1024
  memory_reservation = 1024
  firmware           = "efi"
  guest_id           = "other5xLinux64Guest"
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
    template_uuid = data.vsphere_content_library_item.content_vyos.id
  }
}

resource "vsphere_virtual_machine" "rhel8" {
  name                 = "rhel8"
  datastore_id         = data.vsphere_datastore.datastore.id
  host_system_id       = data.vsphere_host.esxi.id
  resource_pool_id     = data.vsphere_host.esxi.resource_pool_id
  firmware             = "efi"
  guest_id             = "rhel8_64Guest"
  num_cpus             = 2
  memory               = 2048
  memory_reservation   = 2048
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
    template_uuid = data.vsphere_content_library_item.content_rhel8.id
    customize {
      linux_options {
        host_name   = "rhel8"
        domain      = var.domain
	script_text = var.cloudinit-scripts.sshkey
      }
      network_interface {}
    }
  }
}

resource "vsphere_virtual_machine" "kubernetes_master" {
  name                 = "kubernetes_master"
  datastore_id         = data.vsphere_datastore.datastore.id
  host_system_id       = data.vsphere_host.esxi.id
  resource_pool_id     = data.vsphere_host.esxi.resource_pool_id
  firmware             = "efi"
  guest_id             = "rhel8_64Guest"
  num_cpus             = 2
  memory               = 4096
  memory_reservation   = 4096
  wait_for_guest_net_timeout = 0
  wait_for_guest_ip_timeout  = 0
  network_interface {
    network_id     = data.vsphere_network.lab.id
    use_static_mac = true
    mac_address    = var.static-macs.kubernetes-master
    }
  disk {
    label            = "disk0"
    size             = 20
    thin_provisioned = true
  }
  clone {
    template_uuid = data.vsphere_content_library_item.content_rhel8.id
    customize {
      linux_options {
        host_name   = "rhel8"
        domain      = var.domain
        script_text = var.cloudinit-scripts.sshkey
      }
      network_interface {}
    }
  }
}

resource "vsphere_virtual_machine" "kubernetes_worker" {
  count                = var.worker-nodes-no
  name                 = "kubernetes_worker${count.index}"
  datastore_id         = data.vsphere_datastore.datastore.id
  host_system_id       = data.vsphere_host.esxi.id
  resource_pool_id     = data.vsphere_host.esxi.resource_pool_id
  firmware             = "efi"
  guest_id             = "rhel8_64Guest"
  num_cpus             = 2
  memory               = 4096
  memory_reservation   = 4096
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
    template_uuid = data.vsphere_content_library_item.content_rhel8.id
    customize {
      linux_options {
        host_name   = "rhel8"
        domain      = var.domain
        script_text = var.cloudinit-scripts.sshkey
      }
      network_interface {}
    }
  }
}
