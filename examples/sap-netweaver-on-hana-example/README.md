# Example: SAP NetWeaver on HANA Deployment

This example showcases how the underlying modules can be used to deploy the required AWS resources in preparation to install SAP NetWeaver on HANA.

### What's required?

Please review the individual SAP on AWS Terraform modules in this repository to familiarize yourself with the variables and its usage for that module.

### Terraform versions

Terraform 0.12. Pin module version to `~> v2.0`. 

### How to deploy?
1. Make a copy the file `terraform.tfvars.sample` located in this folder.
2. Update the variables to match that of your environment.

### How to set up and execute this sample?
* `terraform init` to initialize the working directory.
* `terraform plan` to create the execution plan which can be reviewed from the console
`terraform apply -var-file=<<input_file_name>>` to apply the changes
* `terraform destroy -var-file=<<input_file_name>>` to destroy the Terraform managed infrastructure