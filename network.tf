data "vsphere_network" "network" {
  name          = var.switches.wan
  datacenter_id = data.vsphere_datacenter.datacenter.id
  depends_on    = [vsphere_host.esxi]
}

data "vsphere_network" "lab" {
  name          = var.switches.lab
  datacenter_id = data.vsphere_datacenter.datacenter.id
  depends_on    = [vsphere_host_port_group.lab-pg]
}

resource "vsphere_host_virtual_switch" "lab" {
  name                   = var.switches.lab
  host_system_id         = data.vsphere_host.esxi.id
  network_adapters       = []
  active_nics            = []
  standby_nics           = []
  allow_promiscuous      = false 
  allow_forged_transmits = true
  allow_mac_changes      = true
}

resource "vsphere_host_port_group" "lab-pg" {
  name                = var.portgroups.lab
  host_system_id      = data.vsphere_host.esxi.id
  virtual_switch_name = vsphere_host_virtual_switch.lab.name
  vlan_id             = var.vlans.lab
  allow_promiscuous   = false
  depends_on          = [vsphere_host_virtual_switch.lab]
}
