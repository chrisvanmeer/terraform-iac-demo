# Terraform Infrastructure as Code Demo

This repository is used for demo purposes to quickly showcase the provisioning of a cloud-based virtual machine running a `nginx` webserver on it, all done with a few lines of Terraform code. Included are examples for the three major cloud providers with guided instructions.

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

## Instructions per provider

### AWS

Please make sure you have your AWS credentials set as environment variables.  
See [this document](https://docs.aws.amazon.com/sdk-for-php/v3/developer-guide/guide_credentials_environment.html) for more instructions on how to do that.
  
Change the `region` attribute in `main.tf` to match your region of choice.

### Azurerm

Please make sure you are authorized to Azure before rolling out the infrastructure.  
An easy way to get setup is by using the [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli).  
Run the `az login` command after installation.

### GCP

The easiest way to authenticate against Google Cloud is through their [CLI toolkit](https://cloud.google.com/sdk/docs/install).  
Run the `gcloud auth login` command after installation.  
  
Change the `project` attribute in `main.tf` to represent your own project.
