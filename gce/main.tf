provider "google" {
  credentials = "${file("${var.credentials_file_path}")}"
  project     = "${var.project}"
  region      = "${var.region}"
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
  name    = "rancher-firewall-quikstart"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["80","443"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["rancher-fw-quikstart"]
}
resource "google_compute_instance" "rancherserver" {
  name          = "${var.prefix}-rancherserver"
  machine_type  = "${var.machine_type}" 
  zone          = "${var.region_zone}"
  tags          = ["rancher-fw-quikstart"]
  boot_disk {
    initialize_params {
       image = "${var.image}" // the operative system (and Linux flavour) that your machine will run
       size  = 100
    }
  }
  metadata {
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
  tags         = ["rancher-fw-quikstart"]
  boot_disk {
    initialize_params {
       image = "${var.image}" // the operative system (and Linux flavour) that your machine will run
       size  = 100
    }
  }
  metadata {
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