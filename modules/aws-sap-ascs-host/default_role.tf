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
  instance_policy_name = "${lower(var.application_code)}-${lower(var.application_name)}-sap_${var.application_component}_default_policy-${lower(var.environment)}"
  instance_role_name   = "${lower(var.application_code)}-${lower(var.application_name)}-sap_${var.application_component}_default_role-${lower(var.environment)}"
}

data "aws_iam_policy_document" "instance_trust" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}
data "aws_iam_policy_document" "instance_policy" {
  #Statements for KMS
  statement {
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey"
    ]
    resources = [var.kms_key_arn]
  }

  # Statement 1 for Stonith when HA installations
  statement {
    actions = [
      "ec2:DescribeInstances",
      "ec2:DescribeInstanceAttribute",
      "ec2:DescribeTags"
    ]
    resources = ["*"]
  }

  # Statement 2 for Stonith when HA installations
  statement {
    actions = [
      "ec2:ModifyInstanceAttribute",
      "ec2:RebootInstances",
      "ec2:StartInstances",
      "ec2:StopInstances"
    ]
    resources = ["arn:aws:ec2:*:*:instance/*"]
  }

  # Statement 1 for Overlay IP when HA installations
  statement {
    actions = [
      "ec2:ReplaceRoute",
      "ec2:DescribeRouteTables"
    ]
    resources = ["arn:aws:ec2:*:*:route-table/*"]
  }

  # Statement 2 for Overlay IP when HA installations
  statement {
    actions = [
      "ec2:ReplaceRoute",
      "ec2:DescribeRouteTables"
    ]
    resources = ["*"]
  }
}

module "default_instance_role" {
  source = "../_internal-modules/security/iam"

  enabled = var.default_instance_role

  policy_name = local.instance_policy_name
  policy      = data.aws_iam_policy_document.instance_policy.json

  aws_managed_policies = ["arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM", "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore", "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"]
  role_name            = local.instance_role_name

  assume_role_policy = data.aws_iam_policy_document.instance_trust.json

  tags = merge(module.tags.values)
}