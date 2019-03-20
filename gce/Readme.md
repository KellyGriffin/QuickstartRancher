# Google Cloud Quickstart

## Pre-requisites
* Google Cloud Platform Account
* ssh keypair 

## Assumptions
* Defalt network will be used
* A GCE project has been created and will be used
  * To get the ID of a project, click on the projects dropdown at the top of the GCP page. A modal will appear with the ID of your projects listed. 

## One time setup steps
1. Clone this repo and go into the azure subfolder
1.  Modify terraform.tfvars file as necessary with:
    * Admin password for Rancher server instance
    * Path to JSON File you will create below (Credentials)
    * Project Name
    * Confirm the location and zone are correct as they default to US Central

2. Create Service Account for JSON File
   1. Select IAM and Admin
   2. Click Service Accounts on the left side pane 
   3. Click Create Service Account 
      1. Provide Name as "terraform" and click Create 
      2. Select Project -> Owner as role from the dropdown, and click Continue
      3. Click on Create Key and download the JSON file
   4. Copy this JSON file to credentials folder and **rename it as terraform.json**
   5. If required - create public and private keys - instructions can be found [here](hhttps://cloud.google.com/compute/docs/instances/adding-removing-ssh-keys) under Create a New SSH Key

## How to use
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