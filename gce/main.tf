provider "google" {
  credentials = "${file("${var.credentials_file_path}")}"
  project     = "${var.project}"
  region      = "${var.region}"
}
variable "username" {
  description = "Your username used for SSH"
  default     = "yourname"
}
variable "sshname" {
  description = "Your username used for SSH"
  default     = "name from ssh key for Gcloud login"
}
variable "region" {
  description = "Region of GCE resources"
  default     = "us-central1"
}

variable "region_zone" {
  description = "Region and Zone of GCE resources"
  default     = "us-central1-a"
}

variable "project" {
	 description = "Name of GCE project"
   default     = "yourlab"
}

variable "machine_type" {
	description = "Type of VM to be created"
	default 		= "n1-standard-4"
}
variable "image" {
	description = "Name of the OS image for compute instances"
	default		  = "ubuntu-os-cloud/ubuntu-1804-bionic-v20190212a"
}

variable "credentials_file_path" {
  description = "Path to the JSON file used to describe your account credentials - service account"
  default     = "terraform.json"
}

variable "public_key_path" {
  description = "Path to file containing public key"
  default     = "~/.ssh/id_rsa.pub"
}

variable "private_key_path" {
  description = "Path to file containing private key"
  default     = "~/.ssh/id_rsa.pub"
}
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
    server_address        = "${google_compute_instance.rancherserver.network_interface.0.access_config.0.nat_ip}"
  }
}
resource "google_compute_firewall" "default" {
  name    = "rancher-firewall"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["80","443"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["rancher-node"]
}
resource "google_compute_instance" "rancherserver" {
  name = "${var.prefix}-rancherserver"
  machine_type = "${var.machine_type}" 
  zone         = "${var.region_zone}"
  tags         = ["rancher-node"]
  boot_disk {
    initialize_params {
       image = "${var.image}" // the operative system (and Linux flavour) that your machine will run
       size  = 100
    }
  }

  metadata {
    ssh-keys = "${var.sshname}:${file("${var.public_key_path}")}"
    startup-script = "${data.template_file.userdata_server.rendered}"
  }
  network_interface {
    network = "default"
    access_config {
      // Ephemeral IP - leaving this block empty will generate a new external IP and assign it to the machine
    }
  }
}

resource "google_compute_instance" "rancheragent-all" {
  name = "${var.prefix}-rancheragent-1-all"
  machine_type = "${var.machine_type}" 
  zone         = "${var.region_zone}"
  tags         = ["rancher-node"]
  boot_disk {
    initialize_params {
       image = "${var.image}" // the operative system (and Linux flavour) that your machine will run
       size  = 100
    }
  }

  metadata {
    ssh-keys = "${var.username}:${file("${var.public_key_path}")}"
    startup-script = "${data.template_file.userdata_agent.rendered}"
  }
  network_interface {
    network = "default"
    access_config {
      // Ephemeral IP - leaving this block empty will generate a new external IP and assign it to the machine
    }
  }
}
output "Rancher Server IP Address" {
  value = [
    "Rancher server: ${google_compute_instance.rancherserver.network_interface.0.access_config.0.nat_ip}",
  ]
}