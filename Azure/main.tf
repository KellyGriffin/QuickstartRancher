provider "azurerm" {
    subscription_id = "xxxx"
    client_id       = "xxxx"
    client_secret   = "xxxx"
    tenant_id       = "xxxx"
}

#Below is so we don't get any naming issues - change to anything you like
variable "prefix" {
  default = "yourname"
}
variable "rancher_version" {
  default = "latest"
}
variable "count_agent_all_nodes" {
  default = "1"
}
variable "count_agent_etcd_nodes" {
  default = "0"
}
variable "count_agent_controlplane_nodes" {
  default = "0"
}
variable "count_agent_worker_nodes" {
  default = "0"
}
variable "admin_password" {
  default = "admin"
}
variable "cluster_name" {
  default = "quickstart"
}
variable "docker_version_server" {
  default = "18.06"
}
variable "docker_version_agent" {
  default = "18.06"
}
# Add name for admin
variable "user" {
  description = "Your name"
  default     = ""
}
variable "servername" {
  description = "The servers name"
  default     = "rancher-server"
}
# Update location of pub file
variable "ssh_public_key_file_path" {
  description = "Location for your SSH Key"
  default     = "<location for pub>/.ssh/id_rsa.pub"
}

# Refer to a resource group that is currently in place
data "azurerm_resource_group" "rg" {
  name = "testrg"
}

# Refer to a subnet that is currenly in place
data "azurerm_subnet" "subnet" {
  name                 = "mySubnet"
  virtual_network_name = "myVnet"
  resource_group_name  = "testrg"
}

# Create public IPs
resource "azurerm_public_ip" "publicip" {
    name                         = "RancherPublicIP"
    location                     = "${data.azurerm_resource_group.rg.location}"
    resource_group_name          = "${data.azurerm_resource_group.rg.name}"
    allocation_method = "Dynamic"

}

# create a network interface
resource "azurerm_network_interface" "rancher-server" {
  name                = "nic-server"
  location            = "${data.azurerm_resource_group.rg.location}"
  resource_group_name = "${data.azurerm_resource_group.rg.name}"

  ip_configuration {
    name                          = "IPconfiguration"
    subnet_id                     = "${data.azurerm_subnet.subnet.id}"
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = "${azurerm_public_ip.publicip.id}"
  }
}
resource "azurerm_network_interface" "rancher-agent" {
  name                = "nic-agent"
  location            = "${data.azurerm_resource_group.rg.location}"
  resource_group_name = "${data.azurerm_resource_group.rg.name}"

  ip_configuration {
    name                          = "IPconfiguration"
    subnet_id                     = "${data.azurerm_subnet.subnet.id}"
    private_ip_address_allocation = "dynamic"
  }
}
data "template_cloudinit_config" "rancherserver-cloudinit" {
  part {
    content_type = "text/x-shellscript"
    content      = "${data.template_file.userdata_server.rendered}"
  }
}
data "template_cloudinit_config" "rancherserver-agent" {
  part {
    content_type = "text/x-shellscript"
    content      = "${data.template_file.userdata_agent.rendered}"
  }
}

# Create virtual machine
resource "azurerm_virtual_machine" "rancher-server" {
    name                  = "${var.servername}-rancherserver"
    location              = "${data.azurerm_resource_group.rg.location}"
    resource_group_name   = "${data.azurerm_resource_group.rg.name}"
    network_interface_ids = ["${azurerm_network_interface.rancher-server.id}"]
    vm_size               = "Standard_DS1_v2"

# Delete the disk automatically when deleting the VM
delete_os_disk_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "serverdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    admin_username = "${var.user}"
    computer_name = "${var.servername}"
    custom_data   = "${data.template_cloudinit_config.rancherserver-cloudinit.rendered}"
  }
  os_profile_linux_config {
   disable_password_authentication = true
    ssh_keys {
      path = "/home/${var.user}/.ssh/authorized_keys"
      key_data = "${file("${var.ssh_public_key_file_path}")}"
    }
  }
}
resource "azurerm_virtual_machine" "rancher-agent" {
    name                  = "${var.servername}-agent"
    location              = "${data.azurerm_resource_group.rg.location}"
    resource_group_name   = "${data.azurerm_resource_group.rg.name}"
    network_interface_ids = ["${azurerm_network_interface.rancher-agent.id}"]
    vm_size               = "Standard_DS1_v2"

# delete the disk automatically when deleting the VM
delete_os_disk_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "agentdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    admin_username = "${var.user}"
    computer_name = "${var.servername}"
    custom_data   = "${data.template_cloudinit_config.rancherserver-agent.rendered}"
  }
  os_profile_linux_config {
   disable_password_authentication = true
    ssh_keys {
      path = "/home/${var.user}/.ssh/authorized_keys"
      key_data = "${file("${var.ssh_public_key_file_path}")}"
    }
  }

#depends_on = ["azurerm_virtual_machine.rancher-server"]
}
data "template_file" "userdata_server" {
  template = "${file("files/userdata_server")}"

  vars {
    admin_password        = "${var.admin_password}"
    cluster_name          = "${var.cluster_name}"
    docker_version_server = "${var.docker_version_server}"
    rancher_version       = "${var.rancher_version}"
  }
}
data "template_file" "userdata_agent" {
  template = "${file("files/userdata_agent")}"

  vars {
    admin_password       = "${var.admin_password}"
    cluster_name         = "${var.cluster_name}"
    docker_version_agent = "${var.docker_version_agent}"
    rancher_version      = "${var.rancher_version}"
    server_address        = "${azurerm_public_ip.publicip.id}"
  }
}
output "Rancher Server IP Address" {
  value = [
    "Rancher server: https://${azurerm_public_ip.publicip.id}",
  ]
}