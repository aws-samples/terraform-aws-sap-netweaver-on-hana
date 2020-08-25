# AWS SAP HANA Infrastructure Terraform module

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
module hana_host {
  source = "./../../../../modules/sap-netweaver-instances/hana-host"

  # If you want high availability
  instance_count = 2
  # Instance type - should be from the list of certified HANA instance sizes
  instance_type = "r5.4xlarge"
  enabled                           = true
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
  # The default security group to be added
  customer_default_sg_id = "default"
  
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
module hana_host {
  source = "./../../../../modules/sap-netweaver-instances/hana-host"

  enabled = false
  # ... omitted
}
```

## Scale Out

If you are setting up scale out system - set the parameter `is_scale_out` to true. In this case the Shared volumes won't be created, a single EFS file share will be create instead

```hcl
# 6 scale out nodes will be provisioned
module hana_host {
  source = "./../../../../modules/sap-netweaver-instances/hana-host"

  instance_count = 6
  is_scale_out = true
  # ... omitted
}
```

## High Availability

If you are setting up highly available system - you can specify how many instances of hana module you need by utilizing the `instance_count` parameter.

In case of scale-out - double the number of nodes.

```hcl
# Two copies of hana instance will be provisioned
module hana_host {
  source = "./../../../../modules/sap-netweaver-instances/hana-host"

  instance_count = 2
  # ... omitted
}
```

## Instance Role

Please provie the required role as a `iam_role` parameter
If none is provided - instance will be created with empty profile

You can set to creation of the default role with SSM authorizations setting up `default_iam_role` to `true`


```hcl
# The provided role will be attached
module hana_host {
  source = "./../../../../modules/sap-netweaver-instances/hana-host"

  iam_role = "instance_role"
  # ... omitted
}
```

```hcl
# The default role will be created and attached
module hana_host {
  source = "./../../../../modules/sap-netweaver-instances/hana-host"

  default_iam_role = true
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

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
|enabled|Enable the provisioning of resources of the module or not|bool|true|No|
|instance_count|Number of instances to be provisioned. In case of scale up scenario - use 2 for HA|number|1|No
|is_scale_out|Defines whether Shared disk should be create as a EFS file system|bool|false|No|
|**instance_type**|Identifies the instance types to be used for HANA. Should be from the list of certified instances, since the disk sizing is done based on this|string| |Yes|
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
|hana_disks_data_storage_type|EBS Volume type for hana data volumes. Can be gp2 or io1|string|gp2|No|
|hana_disks_logs_storage_type|EBS Volume type for hana log volumes. Can be gp2 or io1|string|gp2|No|
|hana_disks_backup_storage_type|EBS Volume type for hana backup volumes|string|st1|No|
|hana_disks_shared_storage_type|EBS Volume type for hana shared volumes|string|gp2|No|
|hana_disks_shared_size|Size in GBs for the hana shared volumes of the instances|number|512|No|
|hana_disks_usr_sap_storage_type|EBS Volume type for hana /usr/sap volumes|string|gp2|No|
|hana_disks_usr_sap_storage_size|Size in GBs for the /usr/sap volumes of the instances|number|50|No|
|**sid**|The System id for the HANA system|string| |Yes|
|**environment**|Environment type for HANA system, e.x. 'dev', 'test', 'prod'|string| |Yes|
|**application_code**|The unique application code for resource naming|string| |Yes|
|**application_name**|The name of the application being provisioned, ex. 'datamart', 'ecc', 's4hana', etc.|string| |Yes|


## License
This library is licensed under the MIT-0 License. See the [LICENSE](LICENSE) file.