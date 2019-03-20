variable "region" {
  description = "Region of GCE resources"
}

variable "region_zone" {
  description = "Region and Zone of GCE resources"
}

variable "project" {
	 description = "Name of GCE project"
}

variable "machine_type" {
	description = "Type of VM to be created"
}

variable "image" {
	description = "Name of the OS image for compute instances"
}

variable "credentials_file_path" {
  description = "Path to the JSON file used to describe your account credentials - service account"
}

variable "prefix" {
  description = "Resources will be prefixed with this to avoid clashing names"
}

variable "rancher_version" {
  description = "rancher/rancher image tag to use"
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