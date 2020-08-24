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
variable "instance_count" {
  default     = 1
  description = "(Optional) Number of instances to be provisioned. Set to two if you also need ERS"
  type        = number
}

variable "instance_type" {
  default     = "m5.xlarge"
  description = "(Optional) Identifies the instance types to be used for ASCS. Should be from the list of certified instances"
  type        = string
}


variable "root_volume_size" {
  default     = 50
  description = "(Optional) Size in GBs for the root volumes of the instances"
  type        = number
}
variable "sapmnt_volume_size" {
  default     = 0
  description = "(Optional) Size in GBs for the /sapmnt volume. Use it only for non-EFS scenario. Not provisioned if value = 0"
  type        = number
}
variable "ami_id" {
  description = "(Required) The AMI id for the underlying OS"
  type        = string
}
variable "ebs_optimized" {
  default     = true
  type        = bool
  description = "(Optional) Defines whether instance should be EBS optimized"
}
variable "ssh_key" {
  description = "(Optional) The key pair name for the instances. If not provided - you can use SSM session manager for console access"
  default     = ""
}
variable "iam_instance_role" {
  type        = string
  description = "(Optional) The IAM role name to be attached to instance profile"
  default     = ""
}
variable "default_instance_role" {
  description = "(Optional) Flag to define whether default instance role should be created"
  default     = false
}
variable "user_data" {
  description = "(Optional) The user data script for the instance. If none provisioned - default one will be used to install AWS CLI and SSM agent"
  default     = ""
}
variable "kms_key_arn" {
  type        = string
  description = "(Optional) KMS Key to be used for EBS volume encryption. If none is provisioned - volumes will not be encrypted"
  default     = ""
}


variable "vpc_id" {
  type        = string
  description = "(Required) VPC to deploy HANA infrastructure to"
}
variable "subnet_ids" {
  description = "(Required) List of subnets for instance distribution"
  type        = list(string)
}
variable "dns_zone_name" {
  default     = ""
  description = "(Optional) The name of Route53 Private DNS zone. If not provided - DNS record will not be created"
  type        = string
}
variable "customer_default_sg_ids" {
  default     = []
  description = "(Optional) List of preexisting security groups to be attached to the instance. The required security groups are created automatically, this is just for mandatory default ones"
}
variable "customer_cidr_blocks" {
  type        = list(string)
  default     = []
  description = "(Optional) The CIDR blocks to allow end-user connectivity from"
}
variable "efs_security_group_id" {
  type        = string
  description = "(Optional) The security group for EFS file system to allow the mount. Required if EFS is used for /sapmnt"
  default     = ""
}


variable "sid" {
  description = "(Required) The System id for the HANA system"
  type        = string
}
variable "environment" {
  description = "(Required) Environment type for HANA system, e.x. 'dev', 'test', 'prod'"
  type        = string
}
variable "application_code" {
  description = "(Required) The unique application code for resource naming"
  type        = string
}
variable "application_name" {
  description = "(Required) The name of the application being provisioned, ex. 'datamart', 'ecc', 's4hana', etc."
  type        = string
}
