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
variable "aws_region" {
  description = "(Required) AWS Region to execute deployment to"
}

variable "hana_instance_type" {
  description = "(Required) Identifies the instance types to be used for HANA. Should be from the list of certified instances, since the disk sizing is done based on this"
  type        = string
}

variable "hana_is_scale_out" {
  default     = false
  description = "(Optional) Defines whether Shared disk should be create as an EFS file system"
  type        = bool
}

variable "enabled" {
  default     = true
  description = "(Optional) Enable the provisioning of resources of the module or not"
  type        = bool
}

variable "ami_id" {
  description = "(Required) The AMI id for the underlying OS"
  type        = string
}

variable "ssh_key" {
  description = "(Optional) The key pair name for the instances. If not provided - you can use SSM session manager for console access"
  default     = ""
}

variable "kms_key_arn" {
  default = ""
  type    = string
}

variable "vpc_id" {
  description = "(Required) VPC to deploy infrastructure to"
  type        = string
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

variable "customer_cidr_blocks" {
  default     = ""
  description = "(Optional) The CIDR blocks to allow end-user connectivity from"
}

variable "customer_default_sg_id" {
  description = "(Optional) List of preexisting security groups to be attached to the instance. The required security groups are created automatically, this is just for mandatory default ones"
}

variable "iam_instance_role" {
  description = "(Optional) The IAM role name to be attached to instance profile"
  type        = string
}

variable "default_instance_role" {
  description = "(Optional) Flag to define whether default instance role should be created"
  default     = true
  type        = bool
}

variable "application_code" {
  description = "(Required) The unique application code for resource naming"
  type        = string
}
variable "application_name" {
  description = "(Required) The name of the application being provisioned, ex. 'datamart', 'ecc', 's4hana', etc."
  type        = string
}
variable "environment_type" {
  description = "(Required) Environment type of SAP Netweaver system, e.x. 'dev', 'test', 'prod'"
  type        = string
}

variable "sid" {
  description = "(Required) The System id for the SAP Netweaver system"
  type        = string
}