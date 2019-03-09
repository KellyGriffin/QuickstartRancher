# Google Cloud Quickstart

## Pre-requisites
* Google Cloud Platform Account
* ssh keypair 

## Assumptions
* Defalt network will be used
* A GCE project has been created and will be used

## One time setup steps
* Clone this repo
* Modify variables.tf file as necessary with:
    * Username for SSH
    * Path to JSON File you will create below (Credentials)
    * Path to Private and Public keys for Authentication
    * Project Name
    * Confirm the location and zone are correct as they default to US Central

> Create Service Account for JSON Files (Credentials required in variables.tf file)
* Select IAM and Admin
* Click Service Accounts on the left side pane 
* Click Create Service Account 
* Provide Name as "terraform" Role as Project owner, select "Create a key" - choose JSON
* Click Create, this will download a JSON file. 
* Copy this JSON file to credentials folder and rename it as terraform.json
* If required - create public and private keys - instructions can be found [here](hhttps://cloud.google.com/compute/docs/instances/adding-removing-ssh-keys) under Create a New SSH Key

### How to use
- Clone this repository and go into the azure subfolder
- Modify the files `terraform.tfvars` and `main.tf` and edit (see inline explanation)
- Run `terraform init`
- Run `terraform plan`
- Run `terraform apply`

When provisioning has finished you will be given the url to connect to the Rancher Server

### How to Remove

To remove the VM's that have been deployed run `terraform destroy --force`

### Optional adding nodes per role
- Start `count_agent_all_nodes` amount of GCP Instances and add them to the custom cluster with all role
- Start `count_agent_etcd_nodes` amount of GCP Instances and add them to the custom cluster with etcd role
- Start `count_agent_controlplane_nodes` amount of GCP Instances and add them to the custom cluster with controlplane role
- Start `count_agent_worker_nodes` amount of Azure Instances and add them to the custom cluster with worker role

**Please be aware that you will be responsible for the usage charges with Google Cloud**