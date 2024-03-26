//data-storage.tf
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

variable "cloud-init" {
  type = map(string)
  default = {
    runcmd = ""
    file = ""
    file-path = ""
  }
}

variable "data-storage" {
  type = map(string)
  default = {
    datacenter = "datacenter1"
    datastore = "datastore1"
    datastore2 = "storage"
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

//vms.tf
variable "static-macs" {
  type = map(string)
  default = {
    kubernetes-master = "00:50:56:97:08:08"
  }
}

variable "static-ips" {
  type = map(string)
  default = {
    ubuntu = "192.168.1.2"
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
