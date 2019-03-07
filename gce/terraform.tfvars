# Admin password to access Rancher
admin_password = "admin"
# Resources will be prefixed with this to avoid clashing names
prefix = "yourname"
# rancher/rancher image tag to use
rancher_version = "latest"
# Region where resources should be created
region = "us-central1"
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

