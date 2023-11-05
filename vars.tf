variable "server_ip" {
  default = ""
}

//data-storage.tf
variable "vyos-data" {
  type = map(string)
  sensitive = true
  default = {
    wan-ip = "192.168.1.4"
    wan-gateway = "192.168.1.1"
    netmask = "24"
    dns = "8.8.8.8"
  }
}

variable "user-data" {
  type = map(string)
  sensitive = true
  default = {
    username = "testuser"
    public-key = ""
    password-hash = ""
  }
}

variable "rhel-subscription" {
  type = map(string)
  default = {
    activation-key = ""
    org = ""
  }
}

variable "data-storage" {
  type = map(string)
  default = {
    datacenter = "datacenter1"
    datastore = "datastore1"
  }
}

//host.tf
variable "host" {
  type = map(string)
  sensitive = true
  default = {
    hostaddress = "192.168.1.100"
    username = "root"
    password = ""
    license = "00000-00000-00000-00000-00000"
  }
}

//main.tf
variable "vcenter" {
  type = map(string)
  sensitive = true
  default = {
    username = "administrator@vsphere.local"
    password = ""
    hostaddress = "192.168.1.200"
  }
}

//network.tf
variable "switches" {
  type = map(string)
  default = {
    wan = "VM Network"
    lab = "LabSwitch"
  }
}

variable "portgroups" {
  type = map(string)
  default = {
    lab = "LabPG"
  }
}

variable "vlans" {
  type = map(string)
  default = {
    lab = 5
  }
}

//templates.tf
variable "templates" {
  type = map(string)
  sensitive = true
  default = {
    vyos = "/downloads/vyos.ova"
    rhel9 = "/downloads/rhel.ova"
    ubuntu = "/downloads/ubuntu.ova"
  }
}

//vms.tf
variable "static-macs" {
  type = map(string)
  default = {
    vyos-wan = "00:55:50:57:52:55"
    vyos-lan = "00:33:30:37:32:33"
    kubernetes-master = "00:50:56:97:08:08"
  }
}

variable "static-ips" {
  type = map(string)
  default = {
    gateway = "192.168.1.1"
  }
}

variable "worker-nodes-no" {
  type = number
  default = 3
}

variable "domain" {
  type = string
  default = "domain.local"
}
