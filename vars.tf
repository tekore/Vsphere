// IP of the Python webserver hosting the os images
variable "server_ip" {
  default = ""
}

//data-storage.tf
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
    hostaddress = ""
    username = ""
    password = ""
    license = ""
    pci-ethernet-mac = ""
  }
}

//main.tf
variable "vcenter" {
  type = map(string)
  sensitive = true
  default = {
    username = ""
    password = ""
    hostaddress = ""
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
    vyos = ""
    rhel9 = ""
    ubuntu = ""
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
    gateway = ""
  }
}

variable "worker-nodes-no" {
  type = number
  default = 3
}

variable "domain" {
  type = string
  sensitive = true
  default = "domain.local"
}
