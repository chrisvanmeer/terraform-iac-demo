# Terraform Infrastructure as Code Demo

This repository is used for demo purposes to quickly showcase the provisioning of a cloud-based virtual machine running a `nginx` webserver on Ubuntu Jammy, all done with Terraform. Included are examples for the three major cloud providers with instructions included on this page.

## Basic instructions

### Clone the repository and choose the provider of your choice

```bash
git clone https://github.com/chrisvanmeer/terraform-iac-demo.git
cd terraform-iac-demo/<provider>
```

### Deploy the infrastructure

```bash
terraform init
terraform plan
terraform apply
```

### Destroy the infrastructure

```bash
terraform destroy
```

## AWS Instructions

Please make sure you are authenticated before continuing.  
An easy way to get setup is by using the [AWS CLI tools](https://aws.amazon.com/cli/).  
Run the `aws configure` command after installation.  
  
See [this](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html) link for more documentation.  
  
Change the `region` attribute in `main.tf` to match your region of choice.

## Azurerm Instructions

Please make sure you are authenticated  before continuing.  
An easy way to get setup is by using the [Azure CLI tools](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli).  
Run the `az login` command after installation.  
  
See [this](https://learn.microsoft.com/en-us/cli/azure/authenticate-azure-cli) link for more documentation.

## GCP Instructions

Please make sure you are authenticated before continuing.  
An easy way to get setup is by using th [GCP CLI tools](https://cloud.google.com/sdk/docs/install).  
Run the `gcloud auth login` command after installation.  
  
See [this](https://cloud.google.com/sdk/gcloud/reference/auth) link for more documentation.  
  
Change the `project` attribute in `main.tf` to represent your own project.
