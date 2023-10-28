// IP of the Python webserver hosting the os images
variable "server_ip" {
  default = ""
}

//data-storage.tf
variable "user-data" {
  type = map(string)
  default = {
    username = "tuser"
    password_hash = "$y$j9T$ONwgItQZd.4prhs72XSzv/$gjVPxeDWk6aA4oLSJCOO5AmIpAPNLZVIBBGCp9GOAfA" #Password here is "Changeme123"
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
    pci-ethernet-mac = "0000:00:00.0"
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
