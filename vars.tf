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
    username = "<Username>"
    password = "<Password>"
    license = "<License-Key>"
    pci-ethernet-mac = "<ESXI-Host-Ethernet-MAC>"
  }
}

//main.tf
variable "vcenter" {
  type = map(string)
  sensitive = true
  default = {
    username = "<Username>@vsphere.local"
    password = "<Password>"
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
    vyos = "http://<Template-Address>/vyos.ova"
    rhel9 = "http://<Template-Address>/rhel.ova"
    truenas = "http://<Template-address>/truenas.ova"
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
