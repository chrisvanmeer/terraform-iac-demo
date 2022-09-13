# Terraform Infrastructure as Code Demo

This repository is used for demo purposes to quickly showcase the provisioning of an AWS EC2 instance running a `nginx` webserver on it, all done with a few lines of Terraform code.

Please make sure you have your AWS credentials set as environment variables.  
See [this document](https://docs.aws.amazon.com/sdk-for-php/v3/developer-guide/guide_credentials_environment.html) for more instructions on how to do that.

## Usage

```bash
git clone https://github.com/chrisvanmeer/terraform-iac-demo.git
cd terraform-iac-demo
terraform init
terraform plan
terraform apply
```
