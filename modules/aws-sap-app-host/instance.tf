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
  hostnames = formatlist("%s", null_resource.hostnames_list.*.triggers.hostname)
}

resource "null_resource" "hostnames_list" {
  count = var.enabled ? var.instance_count : 0

  triggers = {
    hostname = count.index == 0 ? "a${lower(var.application_code)}${lower(var.sid)}pas" : "a${lower(var.application_code)}${lower(var.sid)}aas${count.index + 1}"
  }
}
module "instance" {
  source = "../_internal-modules/compute/ec2-instance-linux"

  enabled = var.enabled

  instance_count = var.enabled ? var.instance_count : 0


  ami              = var.ami_id
  ebs_optimized    = var.ebs_optimized
  instance_type    = var.instance_type
  root_volume_size = var.root_volume_size
  kms_key_arn      = var.kms_key_arn
  ssh_key          = var.ssh_key

  subnet_ids             = var.subnet_ids
  vpc_security_group_ids = flatten([aws_security_group.instance.*.id[0], aws_security_group.sap_application.*.id[0], var.customer_default_sg_ids])
  iam_role               = var.default_instance_role ? module.default_instance_role.role_name : var.iam_instance_role
  hostnames              = local.hostnames
  user_data              = var.user_data


  tags = merge(module.tags.values)
}