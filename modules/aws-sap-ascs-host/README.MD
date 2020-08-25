# AWS SAP NetWeaver ASCS Server Infrastructure Terraform module

Terraform module which creates EC2 resources for SAP HANA on AWS

These types of resources are supported:

* [EC2 instances](https://www.terraform.io/docs/providers/aws/r/instance.html)
* [EBS Volumes](https://www.terraform.io/docs/providers/aws/r/ebs_volume.html)
* [Security Groups](https://www.terraform.io/docs/providers/aws/r/security_group.html)
* [DNS Record](https://www.terraform.io/docs/providers/aws/r/route53_record.html)
* [Tags Module](../_internal-modules/common/tagging)

## Terraform versions

Terraform 0.12. Pin module version to `~> v2.0`. Submit pull-requests to `mainline` branch.

## Usage example

```hcl
module sap_ascs_hosts {
  source = "./../../../../modules/sap-netweaver-instances/sap-app-host"

  enabled                           = true

  # Provision two if you also need an ERS
  instance_count = 2
  # Instance type - should be from the list of certified SAP instance sizes
  instance_type = "m5.large"
  ami_id                            = "ami-xxxxxxxxx"

  # General

  # KMS Key for EBS Volumes Encryption
  kms_key_arn = "arn:aws:kms:us-east-1:xxxxxxx:key/5b6f7d73-8407-4c4e-b6f3-xxxxxxx"

  # Networking
  vpc_id                            = "vpc-xxxxxxx"

  # The list of subnets to deploy the instances
  subnet_ids                 = ["subnet-xxxxxx", "subnet-xxxxxx"]
  # The Route53 private Zone name to create the host entry
  dns_zone_name                 = "domain.ext"
  # The CIDR block for the onPremise Network
  customer_cidr_blocks                = ["xx.xx.xx.xx/xx"]
  # The default security groups to be added
  customer_default_sg_ids = [ "default" ]
  
  # Instance Role
  iam_instance_role = "sap-instance-role"

  # Tags
  application_code = "S4H"
  environment = "prod"
  application_name = "ECC"
  
  # SAP
  sid = "DWE"
}
```

## Conditional creation

Sometimes you need to have a way to create instances conditionally but Terraform does not allow to use `count` inside `module` block, so the solution is to specify argument `enabled`.

```hcl
# This VPC will not be created
module sap_ascs_hosts {
  source = "./../../../../modules/sap-netweaver-instances/hana-host"

  enabled = false
  # ... omitted
}
```

## Instance Role

Please provie the required role as a `iam_role` parameter
If none is provided - instance will be created with empty profile

You can set to creation of the default role with SSM authorizations setting up `default_iam_role` to `true`


```hcl
# The provided role will be attached
module sap_ascs_hosts {
  source = "./../../../../modules/sap-netweaver-instances/sap_app_host"

  iam_role = "instance_role"
  # ... omitted
}
```

```hcl
# The default role will be created and attached
module sap_ascs_hosts {
  source = "./../../../../modules/sap-netweaver-instances/sap_app_host"

  default_iam_role = true
  # ... omitted
}
```

## /sapmnt usage

Two scenarios possible for /sapmnt folder:

 * EBS volume for /sapmnt
 * EFS File system for /sapmnt

This is controlled by two variables:

 * `efs_security_group_id` - (**Required if EFS is used for /sapmnt**)The security group for EFS file system to allow the mount
 * `sapmnt_volume_size` - (**Required for non-EFS scenario**) Size in GBs for the /sapmnt volume. Not provisioned if value = 0

To create and attach EBS volume provision the parameter:

```hcl
# Will create and attach EBS volume for /sapmnt mount
module sap_ascs_hosts {
  source = "./../../../../modules/sap-netweaver-instances/sap_app_host"

  sapmnt_volume_size = 128
  # ... omitted
}
```

To allow connectivity to EFS file system:

```hcl
# Will allow the connectivity to EFS file system with the provided security group
module sap_ascs_hosts {
  source = "./../../../../modules/sap-netweaver-instances/sap_app_host"

  efs_security_group_id = "sg-123456789"
  # ... omitted
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | ~> 0.12.6 |
| aws | ~> 2.53 |

## Providers

| Name | Version |
|------|---------|
| aws | ~> 2.53 |

## Inputs

(Mandatory input variables are in bold)

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
|enabled|Enable the provisioning of resources of the module or not|bool|true|No|
|instance_count|Number of instances to be provisioned|number|1|No
|**instance_type**|Identifies the instance types to be provisioned. Should be from the list of certified instances, since the disk sizing is done based on this|string| |Yes|
|ebs_optimized|Defines whether instance should be EBS optimized|bool|true|No|
|default_instance_role|Flag to define whether default instance role should be created|bool|false|No|
|iam_instance_role|The IAM role name to be attached to instance profile|string| |No|
|kms_key_arn|KMS Key to be used for EBS volume encryption. If none is provisioned - volumes will not be encrypted|string| |No|
|user_data|The user data script for the instance. If none provisioned - default one will be used to install AWS CLI and SSM agent|string| |No|
|**vpc_id**|VPC to deploy HANA infrastructure to|string| |Yes|
|**subnet_ids**|List of subnets for instance distribution|StringList| | Yes|
|dns_zone_name|The name of Route53 Private DNS zone. If not provided - DNS record will not be created|string| |No|
|customer_default_sg_id|List of preexisting security groups to be attached to the instance|StringList| |No|
|customer_cidr_blocks|The CIDR blocks to allow end-user connectivity from|StringList| |No|
|**ami_id**|The AMI id for the underlying OS|string| |Yes|
|ssh_key|The key pair name for the instances. If not provided - you can use SSM session manager for console access|string| |No|
|root_volume_size|Size in GBs for the root volumes of the instances|Number|50|No|
|efs_security_group_id|(**Required if EFS is used for /sapmnt**)The security group for EFS file system to allow the mount. |string| |No|
|sapmnt_volume_size|(**Required for non-EFS scenario**) Size in GBs for the /sapmnt volume. Not provisioned if value = 0|Number|0|No|
|**sid**|The System id for the HANA system|string| |Yes|
|**environment**|Environment type for HANA system, e.x. 'dev', 'test', 'prod'|string| |Yes|
|**application_code**|The unique application code for resource naming|string| |Yes|
|**application_name**|The name of the application being provisioned, ex. 'datamart', 'ecc', 's4hana', etc.|string| |Yes|


## License
This library is licensed under the MIT-0 License. See the [LICENSE](LICENSE) file.