# SAP NetWeaver on HANA Module

A Terraform module that will create the the following AWS Resources to build and deploy a SAP NetWeaver on HANA Solution.

* EFS file system for `/sapmnt`
* HANA host(s)
* ASCS host(s)
* Application Server host(s)

For each of the SAP Components the following resources can be created:

* [EC2 instances](https://www.terraform.io/docs/providers/aws/r/instance.html)
* [EBS Volumes](https://www.terraform.io/docs/providers/aws/r/ebs_volume.html)
* [Security Groups](https://www.terraform.io/docs/providers/aws/r/security_group.html)
* [DNS Record](https://www.terraform.io/docs/providers/aws/r/route53_record.html)
* [Tags](../_internal-modules/common/tagging)
* [IAM Roles](https://www.terraform.io/docs/providers/aws/r/iam_role.html)
* [EC2 Instance AutoRecovery](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-instance-recover.html)
* [EC2 User Data](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/user-data.html)
* [EBS Volumes Encryption](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/EBSEncryption.html)

The following modules are embedded into the module and can be reused separately. Each sub module has it's own usage documented in the submodule folders as listed below.

* [SAP HANA Instance Module](./modules/aws-sap-hana-host)
* [ASCS Instance Module](./modules/aws-sap-ascs-host)
* [Application Server Instance Module](./modules/aws-sap-app-host)


## Terraform versions

Terraform 0.15. Pin module version to `~> v2.0`. 

## Requirements

| Name | Version |
|------|---------|
| terraform | ~> 0.12.6 |
| aws | ~> 2.53 |

## Providers

| Name | Version |
|------|---------|
| aws | ~> 2.53 |


## License
This library is licensed under the MIT-0 License. See the [LICENSE](LICENSE) file.