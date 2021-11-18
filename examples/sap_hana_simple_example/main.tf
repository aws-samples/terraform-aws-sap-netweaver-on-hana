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

locals {
  binaries_bucket_name = ""
}
module "hana_host" {
  source                 = "../../modules/aws-sap-hana-host"
  instance_count         = 1
  user_data              = data.template_file.hana_userdata.rendered
  instance_type          = var.hana_instance_type
  is_scale_out           = var.hana_is_scale_out
  enabled                = var.enabled
  ami_id                 = var.ami_id
  kms_key_arn            = var.kms_key_arn
  ssh_key                = var.ssh_key
  vpc_id                 = var.vpc_id
  subnet_ids             = var.subnet_ids
  dns_zone_name          = var.dns_zone_name
  customer_cidr_blocks   = var.customer_cidr_blocks
  customer_default_sg_id = var.customer_default_sg_id
  iam_instance_role      = var.default_instance_role ? "" : var.iam_instance_role
  default_instance_role  = var.default_instance_role
  application_code       = lower(var.application_code)
  environment            = lower(var.environment_type)
  application_name       = lower(var.application_name)
  sid                    = var.sid
}

module "sap_deployment" {
  source               = "../../modules/sap-deploymentscripts"
  binaries_bucket_name = local.binaries_bucket_name
  binaries_key_arn     = var.kms_key_arn
  binaries_folder      = ""
  hana_instance_ids    = module.hana_host.instance_ids
  kms_key_arn          = var.kms_key_arn
  dns_zone_name        = var.dns_zone_name
  product              = "S4HANA1909.CORE.HDB.ABAP"
  application_code     = lower(var.application_code)
  environment          = lower(var.environment_type)
  application_name     = lower(var.application_name)
}