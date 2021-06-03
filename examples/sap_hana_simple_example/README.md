# Sample configuration : AWS Resources for deploying Amazon EC2 instances, AWS Systems Manager Document to build and configure SAP HANA

The Terraform configuration in the `examples/sap_hana_simple_example` directory has a sample configuration to deploy Amazon EC2 instances along with a series of AWS Systems Manager Documents which simplify the task of configuration the operating system and proceed with the installation of SAP HANA.

### What's required?
SAP HANA media needs to be uploaded to Amazon S3. Create a root folder with any name and it should contain a subfolder named `HANA20SPS05` which should contain the media.

### What version does this support?
The SAP HANA installation takes place via an AWS Systems Manager Automation Document. This has been tested with SAP HANA 20 SPS05. The SSM Automation Document itself can be adapted to any SAP HANA version as needed.

### Terraform versions
Terraform >=0.15

### How to deploy?
Update `terraform.tfvars` as appropriate to match your AWS account

### How to set up and execute this sample?
* `terraform init` to initialize the working directory.
* `terraform plan -out=deploy.plan` to create the execution plan which can be reviewed from the console
* `terraform apply deploy.plan` to apply the changes
* `terraform destroy` to destroy the Terraform managed infrastructure

### How to configure the OS and Deploy SAP HANA
1. After executing `terraform apply deploy.plan` login to the AWS account and validate the AWS resources which were created.
2. From the console navigate to AWS Systems Manager -> Documents->Owned by me. Here you will find the 2 automation documents.
    * `[application_name]-bootstrap-hana-instance`: This document does the following - 
        * Sets the hostname
        * Install's OS packaged required for SAP HANA
        * Configures OS Parameters required for HANA
        * Configures the disks
        * Installs AWS Data Provider for SAP
        * Reboots the instance
    * `[application_name]-install-hana-master-document`: This document does the following - 
        * Reads the password from AWS Parameter Store, this will be used in the SAP HANA installation process
        * Reads the SID from the `SID` tag from the EC2 instance which was selected for SAP HANA installation 
        * Downloads the SAP HANA software from S3 bucket
        * Executes the SAP HANA Installation
3. Execute the document `[application_name]-bootstrap-hana-instance` from AWS Systems Manager to bootstrap the EC2 instance
![Execute Bootstrap SAP HANA EC2 Instance](../../images/bootstrap-hana-instance.png?raw=true "Execute Bootstrap SAP HANA EC2 Instance")
    * Click the `Execute automation` button from the above screen and it will navigate to the execution screen for selection of EC2 instances & parameters. Select the EC2 instance which was created and click the `Execute` button
    ![Execute Bootstrap SAP HANA EC2 Instance](../../images/execute-automation-document.png?raw=true "Execute Bootstrap SAP HANA EC2 Instance")
    ![Select or Enter Parameters](../../images/execute-automation-document-parameters.png?raw=true "Execute Bootstrap SAP HANA EC2 Instance")
    * The bootstrapping of the document will now kick in and might take a couple of minutes. Upon successful completion, the below screen should show up.
    ![Bootstrapping Complete](../../images/execute-automation-document-complete.png?raw=true "Execute Bootstrap SAP HANA EC2 Instance")
    * This concludes the bootstrapping process and the EC2 instance is now ready for SAP HANA installation.
4. Execute the document `[application_name]-install-hana-master-document` to begin the process for SAP HANA installation.![Execute SAP HANA Installation SSM Document](../../images/execute-automation-document-hana-install.png?raw=true "Execute SAP HANA Installation SSM Document")
    * Click the `Execute Automation` button to navigate to the screen where you will select the EC2 instance which was previously bootstrapped. Also enter the S3 bucket name where the SAP HANA Media is located.
![Execute SAP HANA Installation SSM Document](../../images/execute-hana-install-automation.png?raw=true "Execute SAP HANA Installation SSM Document")
![Bootstrapping Complete](../../images/execute-hana-install-automation-parameters.png?raw=true "Execute SAP HANA Installation SSM Document")
* Click on the `Execute` button to proceed with the execution of the automation document which will start the process of SAP HANA installation.
* Once the installation begins, the log files can be monitored by logging into the instance via AWS Systems Manager Session and navigating to the `/var/tmp` directory.

