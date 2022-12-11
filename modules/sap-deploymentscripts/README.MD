 ## SAP Provisioning Terraform Module
 
 The provided module provisions all the required Systems Manager Automations for provisioning the SAP Netweaver on HANA distributed installation

 - HANA DB Host
 - ASCS Instance on separate host
 - ABAP DB Instance and PAS instance (Central Instance)

 ### Prerequisites:

 1. Make sure that hostname is maintained in EC2 instance tags as `Hostname`
 2. Make sure that SAP SID is maintained in EC2 instance tags as `Sid`
 3. Download and put all the necessary binaries into specified folder
 4. Make sure, that user executing the automation has all required authorizations, otherwise provide the automation role as a parameter
 5. Make sure that all instances are based on AWS Nitro platform
 6. Create and attach the EBS volumes to the instances with the following EBS mapping:
  
  Instance       | /usr/sap      | /hana/data                     | /hana/log           | /backup       | /hana/shared  | swap
  -------------- | ------------- | ------------------------------ | ------------------- | ------------- | ------------- | -------------
  HanaInstanceId | /dev/xvdq     | /dev/xvdf,/dev/xvdg,/dev/xvdh  | /dev/xvdm,/dev/xvdn | /dev/xvdp     | /dev/xvdo     | /dev/xvdr
  PasInstanceId  | /dev/xvdf     | -                              |                     |               |               | /dev/xvdg
  AscsInstanceId | /dev/xvdf     | -                              |                     |               |               | /dev/xvdg

  The /sapmnt will be mounted on provided EFS folder

  **If the prerequisites are not met - the installation will definitely fail!**

 ### Limitations

- Current version only support the provisioning of HANA instance, one ASCS instance and one PAS instance
- The support for HA will be added later
- ONLY for RedHat for SAP with HA and US AMI from Marketplace

 ### Usage:

 Add this module to your terraform configuration and provide the variables:

 ```json
 module sap_provisioning {
  source = "./../modules/sap-provisioning"
  
  # Media Source
  binaries_bucket_name = "palkinvp-installation-media" # your bucket with Installation media. 
  
  # Infrastructure Details
  hana_instance_ids = module.hana_host.instance_ids # - the list of HANA instance ids. Currently only first one is considered
  ascs_instance_id = module.sap_ascs_host.instance_ids[0] # - the instance id for ASCS
  pas_instance_id = module.sap_app_host.instance_ids[0]
  app_server_instance_ids = module.sap_app_host.instance_ids
  efs_sapmnt = module.sap_efs.efs_file_system_id
  
  # Security Details
  kms_key_arn = module.generic_tools.application_kms_key.arn
  dns_zone_name = var.dns_zone_name
  
  # SAP
  sid = var.sid
  db_product = "NW_ABAP_DB:NW750.HDB.ABAPHA"
  ascs_product = "NW_ABAP_ASCS:NW750.HDB.ABAPHA"
  pas_product = "NW_ABAP_CI:NW750.HDB.ABAPHA"

  # Tags
  app_code = lower(local.app_code)
  environment = lower(var.environment_type)
  application_name = lower(local.application_name)
}
```

 ## Outputs

  Currently not outputting any values

 ## Development tips.

FIRST RULE OF FIGHT CLUB: Keep it simple, try to keep the signature of the module and structure unchanged


- `scripts` folder contains the YAML templates for the automation documents and Run Commands to install HANA, ASCS and PAS. If the SSM Documents can be re-used in multiple SAP components - they are put int `shared` subfolders
- `*-ssm-documents.tf` - terraform resources to provision all the neccessary SSM Documents. The automation documents receive the names of the included command documents via the `templatefile` function. Please keep it this way
- `parameter-store.tf` - the creation of required parameters for SAP system installations, such as users and passwords
- `sap-inst-settings-to-s3.tf` - the sapinst process requires the parameter files for silent install for each module of the distributed system. This terraform module uploads the templates to s3 binaries bucket, so that they could be donwloaded during installation
- `sap-setup-log-group.tf` - all the automations put the logs to the created CloudWatch Log group

There is a plan to continue developing this module to support high availability and SuSe
