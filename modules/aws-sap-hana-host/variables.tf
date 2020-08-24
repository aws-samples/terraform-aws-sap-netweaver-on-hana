/*
 * Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
 * SPDX-License-Identifier: MIT-0
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of this
 * software and associated documentation files (the "Software"), to deal in the Software
 * without restriction, including without limitation the rights to use, copy, modify,
 * merge, publish, distribute, sublicense, and/or sell copies of the Software, and to
 * permit persons to whom the Software is furnished to do so.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
 * INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
 * PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 * HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
 * OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
 * SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

variable "enabled" {
  default     = true
  description = "(Optional) Enable the provisioning of resources of the module or not"
  type        = bool
}

# EC2 Instance Parameters
variable "instance_count" {
  default     = 1
  description = "(Optional) Number of instances to be provisioned. In case of scale up scenario - use 2 for HA. "
}

variable "is_scale_out" {
  default     = false
  description = "(Optional) Defines whether Shared disk should be create as a EFS file system"
}

variable "instance_type" {
  description = "(Required) Identifies the instance types to be used for HANA. Should be from the list of certified instances, since the disk sizing is done based on this"
}

variable "ebs_optimized" {
  description = "(Optional) Defines whether instance should be EBS optimized"
  default     = true
}
variable "default_instance_role" {
  description = "(Optional) Flag to define whether default instance role should be created"
  default     = false
}
variable "iam_instance_role" {
  description = "(Optional) The IAM role name to be attached to instance profile"
  default     = ""
}
variable "kms_key_arn" {
  description = "(Optional) KMS Key to be used for EBS volume encryption. If none is provisioned - volumes will not be encrypted"
  default     = ""
}
variable "user_data" {
  description = "(Optional) The user data script for the instance. If none provisioned - default one will be used to install AWS CLI and SSM agent"
  default     = ""
}


# Networking Variables
variable "vpc_id" {
  description = "(Required) VPC to deploy HANA infrastructure to"
}

variable "subnet_ids" {
  description = "(Required) List of subnets for instance distribution"
}
variable "dns_zone_name" {
  default     = ""
  description = "(Optional) The name of Route53 Private DNS zone. If not provided - DNS record will not be created"
}
variable "customer_default_sg_id" {
  default     = []
  description = "(Optional) List of preexisting security groups to be attached to the instance. The required security groups are created automatically, this is just for mandatory default ones"
}
variable "customer_cidr_blocks" {
  default     = ""
  description = "(Optional) The CIDR blocks to allow end-user connectivity from"
}


# OS Parameters
variable "ami_id" {
  description = "(Required) The AMI id for the underlying OS"
}
variable "ssh_key" {
  description = "(Optional) The key pair name for the instances. If not provided - you can use SSM session manager for console access"
  default     = ""
}


# HANA Sizing
variable "root_volume_size" {
  default     = 50
  description = "(Optional) Size in GBs for the root volumes of the instances"
}
variable "hana_disks_data_storage_type" {
  default     = "gp2"
  description = "(Optional) EBS Volume type for hana data volumes. Can be gp2 or io1"
}
variable "hana_disks_logs_storage_type" {
  default     = "gp2"
  description = "(Optional) EBS Volume type for hana log volumes. Can be gp2 or io1"
}
variable "hana_disks_backup_storage_type" {
  default     = "st1"
  description = "(Optional) EBS Volume type for hana backup volumes."
}
variable "hana_disks_shared_storage_type" {
  default     = "gp2"
  description = "(Optional) EBS Volume type for hana shared volumes."
}
variable "hana_disks_shared_size" {
  default     = "512"
  description = "(Optional) Size in GBs for the hana shared volumes of the instances"
}
variable "hana_disks_usr_sap_storage_type" {
  default     = "gp2"
  description = "(Optional) EBS Volume type for hana /usr/sap volumes. "
}
variable "hana_disks_usr_sap_storage_size" {
  default     = "50"
  description = "(Optional) Size in GBs for the /usr/sap volumes of the instances"
}

variable "sid" {
  description = "(Required) The System id for the HANA system"
}
variable "environment" {
  description = "(Required) Environment type for HANA system, e.x. 'dev', 'test', 'prod'"
}
variable "application_code" {
  description = "(Required) The unique application code for resource naming"
}
variable "application_name" {
  description = "(Required) The name of the application being provisioned, ex. 'datamart', 'ecc', 's4hana', etc."
}