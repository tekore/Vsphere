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
    hostaddress = "<ESXI-IP>"
    username = "username"
    password = "Password123"
    license = "<License-Key>"
    pci-ethernet-mac = "<ESXI-HOST-ETHERNET-MAC>"
  }
}

//main.tf
variable "vcenter" {
  type = map(string)
  sensitive = true
  default = {
    username = "username@vsphere.local"
    password = "Password123"
    hostaddress = "<VCenter-IP>"
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
    vyos = "http://<TEMPLATE-ADDRESS>/vyos.ovf"
    rhel8 = "http://<TEMPLATE-ADDRESS>/rhel8.ovf"
    truenas = "http://<TEMPLATE-ADDRESS>/truenas.ovf"
  }
}

//vms.tf
variable "static-macs" {
  type = map(string)
  default = {
    kubernetes-master = "00:50:56:97:08:08"
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

variable "cloudinit-scripts" {
  type = map(string)
  sensitive = true
  default = {
    sshkey = <<EOF
#!/bin/sh
if [ x$1 = x"precustomization" ]; then
    echo "Do Precustomization tasks"
    mkdir -p /root/.ssh ; echo 'ssh-rsa <KEY HERE>' >>/root/.ssh/authorized_keys
elif [ x$1 = x"postcustomization" ]; then
    echo "Do Postcustomization tasks"
fi
EOF
  }
}
