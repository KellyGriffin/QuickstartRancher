# Path to the JSON file used to describe your account credentials - service account
credentials_file_path = "terraform.json"

# Admin password to access Rancher
admin_password = "admin"

# Resources will be prefixed with this to avoid clashing names
prefix = "yourname"

# rancher/rancher image tag to use
rancher_version = "latest"

# The GCE project in which to stand up resources
project = "sincere-charmer-235119"

# Region where resources should be created
region = "us-central1"

# Zone within the region
region_zone = "us-central1-a"

# Type of VM to be created
machine_type = "n1-standard-4"

# Name of the OS image for compute instances
image = "ubuntu-os-cloud/ubuntu-1804-bionic-v20190212a"

# Count of agent nodes with role all
count_agent_all_nodes = "1"

# Count of agent nodes with role etcd
count_agent_etcd_nodes = "0"

# Count of agent nodes with role controlplane
count_agent_controlplane_nodes = "0"

# Count of agent nodes with role worker
count_agent_worker_nodes = "0"

# Docker version of host running `rancher/rancher`
docker_version_server = "18.06"

# Docker version of host being added to a cluster (running `rancher/rancher-agent`)
docker_version_agent = "18.06"