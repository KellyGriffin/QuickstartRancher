## Microsoft Azure quickstart

> Getting started

The following assumes:
* You have an Azure account with sufficient credit on it. And you have clear understanding on how Azure charges you.
* You have SSH keys on your machine, otherwise check [here](https://confluence.atlassian.com/bitbucketserver/creating-ssh-keys-776639788.html)
* You know which Region to implement your Rancher server and which image you would like to utilise

> **Please note the configuration deployed will use resources that you/your organisation will be charged for.**

### Pre-Work - Create service principal on Azure

This creates an access to Azure APIs that terraform will use to create the resources.

1. [Create a service principal to provide authentication](https://www.terraform.io/docs/providers/azurerm/authenticating_via_service_principal.html)
2. Modify the connection settings within the main.tf with the details created/obtained from above
```INI
client_id       = "XXXX"
client_secret   = "XXXX"
tenant_id       = "XXXX"
subscription_id = "XXXX"
```

### How to use
- Clone this repository and go into the azure subfolder
- Modif the files `variables.tfvars` and `main.tf` and edit (see inline explanation)
- Run `terraform init`
- Run `terraform apply`

When provisioning has finished you will be given the url to connect to the Rancher Server

### How to Remove

To remove the VM's that have been deployed run `terraform destroy --force`

### Optional adding nodes per role
- Start `count_agent_all_nodes` amount of Azure Instances and add them to the custom cluster with all role
- Start `count_agent_etcd_nodes` amount of Azure Instances and add them to the custom cluster with etcd role
- Start `count_agent_controlplane_nodes` amount of Azure Instances and add them to the custom cluster with controlplane role
- Start `count_agent_worker_nodes` amount of Azure Instances and add them to the custom cluster with worker role

**Please be aware that you will be responsible for the usage charges with Microsoft Azure**