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

resource "aws_security_group" "sap_application" {
  count  = var.enabled ? 1 : 0
  name   = "${module.tags.values["Name"]}-sap-sg"
  vpc_id = var.vpc_id


  lifecycle {
    ignore_changes        = [description]
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "sap_application_http_in" {
  count             = var.enabled ? 1 : 0
  security_group_id = aws_security_group.sap_application.*.id[0]
  type              = "ingress"
  from_port         = "80"
  to_port           = "80"
  protocol          = "tcp"
  cidr_blocks       = flatten([data.aws_vpc.vpc.cidr_block, var.customer_cidr_blocks])
}

resource "aws_security_group_rule" "sap_application_https_in" {
  count             = var.enabled ? 1 : 0
  security_group_id = aws_security_group.sap_application.*.id[0]
  type              = "ingress"
  from_port         = "443"
  to_port           = "443"
  protocol          = "tcp"
  cidr_blocks       = flatten([data.aws_vpc.vpc.cidr_block, var.customer_cidr_blocks])
}

resource "aws_security_group_rule" "sap_application_tcp515_in" {
  count             = var.enabled ? 1 : 0
  security_group_id = aws_security_group.sap_application.*.id[0]
  type              = "ingress"
  from_port         = "515"
  to_port           = "515"
  protocol          = "tcp"
  cidr_blocks       = [data.aws_vpc.vpc.cidr_block]
}

resource "aws_security_group_rule" "sap_application_tcp1128-1129_in" {
  count             = var.enabled ? 1 : 0
  security_group_id = aws_security_group.sap_application.*.id[0]
  type              = "ingress"
  from_port         = "1128"
  to_port           = "1129"
  protocol          = "tcp"
  cidr_blocks       = [data.aws_vpc.vpc.cidr_block]
}

resource "aws_security_group_rule" "sap_application_tcp3200_in" {
  count             = var.enabled ? 1 : 0
  security_group_id = aws_security_group.sap_application.*.id[0]
  type              = "ingress"
  from_port         = "3200"
  to_port           = "3200"
  protocol          = "tcp"
  cidr_blocks       = flatten([data.aws_vpc.vpc.cidr_block, var.customer_cidr_blocks])
}

resource "aws_security_group_rule" "sap_application_tcp3298-3301_in" {
  count             = var.enabled ? 1 : 0
  security_group_id = aws_security_group.sap_application.*.id[0]
  type              = "ingress"
  from_port         = "3298"
  to_port           = "3301"
  protocol          = "tcp"
  cidr_blocks       = flatten([data.aws_vpc.vpc.cidr_block, var.customer_cidr_blocks])
}

resource "aws_security_group_rule" "sap_application_tcp3600-3601_in" {
  count             = var.enabled ? 1 : 0
  security_group_id = aws_security_group.sap_application.*.id[0]
  type              = "ingress"
  from_port         = "3600"
  to_port           = "3601"
  protocol          = "tcp"
  cidr_blocks       = flatten([data.aws_vpc.vpc.cidr_block, var.customer_cidr_blocks])
}

resource "aws_security_group_rule" "sap_application_tcp4300_in" {
  count             = var.enabled ? 1 : 0
  security_group_id = aws_security_group.sap_application.*.id[0]
  type              = "ingress"
  from_port         = "4300"
  to_port           = "4300"
  protocol          = "tcp"
  cidr_blocks       = [data.aws_vpc.vpc.cidr_block]
}

resource "aws_security_group_rule" "sap_application_tcp4800_in" {
  count             = var.enabled ? 1 : 0
  security_group_id = aws_security_group.sap_application.*.id[0]
  type              = "ingress"
  from_port         = "4800"
  to_port           = "4800"
  protocol          = "tcp"
  cidr_blocks       = [data.aws_vpc.vpc.cidr_block]
}

resource "aws_security_group_rule" "sap_application_tcp5050_in" {
  count             = var.enabled ? 1 : 0
  security_group_id = aws_security_group.sap_application.*.id[0]
  type              = "ingress"
  from_port         = "5050"
  to_port           = "5050"
  protocol          = "tcp"
  cidr_blocks       = [data.aws_vpc.vpc.cidr_block]
}

resource "aws_security_group_rule" "sap_application_tcp8000_in" {
  count             = var.enabled ? 1 : 0
  security_group_id = aws_security_group.sap_application.*.id[0]
  type              = "ingress"
  from_port         = "8000"
  to_port           = "8000"
  protocol          = "tcp"
  cidr_blocks       = [data.aws_vpc.vpc.cidr_block]
}

resource "aws_security_group_rule" "sap_application_tcp8100_in" {
  count             = var.enabled ? 1 : 0
  security_group_id = aws_security_group.sap_application.*.id[0]
  type              = "ingress"
  from_port         = "8100"
  to_port           = "8100"
  protocol          = "tcp"
  cidr_blocks       = [data.aws_vpc.vpc.cidr_block]
}

resource "aws_security_group_rule" "sap_application_tcp20201_in" {
  count             = var.enabled ? 1 : 0
  security_group_id = aws_security_group.sap_application.*.id[0]
  type              = "ingress"
  from_port         = "20201"
  to_port           = "20201"
  protocol          = "tcp"
  cidr_blocks       = [data.aws_vpc.vpc.cidr_block]
}

resource "aws_security_group_rule" "sap_application_tcp30009-30033_in" {
  count             = var.enabled ? 1 : 0
  security_group_id = aws_security_group.sap_application.*.id[0]
  type              = "ingress"
  from_port         = "30009"
  to_port           = "30033"
  protocol          = "tcp"
  cidr_blocks       = [data.aws_vpc.vpc.cidr_block]
}

resource "aws_security_group_rule" "sap_application_tcp30040-30048_in" {
  count             = var.enabled ? 1 : 0
  security_group_id = aws_security_group.sap_application.*.id[0]
  type              = "ingress"
  from_port         = "30040"
  to_port           = "30048"
  protocol          = "tcp"
  cidr_blocks       = [data.aws_vpc.vpc.cidr_block]
}

resource "aws_security_group_rule" "sap_application_tcp40000_in" {
  count             = var.enabled ? 1 : 0
  security_group_id = aws_security_group.sap_application.*.id[0]
  type              = "ingress"
  from_port         = "40000"
  to_port           = "40000"
  protocol          = "tcp"
  cidr_blocks       = [data.aws_vpc.vpc.cidr_block]
}

resource "aws_security_group_rule" "sap_application_tcp44300_in" {
  count             = var.enabled ? 1 : 0
  security_group_id = aws_security_group.sap_application.*.id[0]
  type              = "ingress"
  from_port         = "44300"
  to_port           = "44300"
  protocol          = "tcp"
  cidr_blocks       = [data.aws_vpc.vpc.cidr_block]
}

resource "aws_security_group_rule" "sap_application_tcp44400_in" {
  count             = var.enabled ? 1 : 0
  security_group_id = aws_security_group.sap_application.*.id[0]
  type              = "ingress"
  from_port         = "44400"
  to_port           = "44400"
  protocol          = "tcp"
  cidr_blocks       = [data.aws_vpc.vpc.cidr_block]
}

resource "aws_security_group_rule" "sap_application_tcp50013-50014_in" {
  count             = var.enabled ? 1 : 0
  security_group_id = aws_security_group.sap_application.*.id[0]
  type              = "ingress"
  from_port         = "50013"
  to_port           = "50014"
  protocol          = "tcp"
  cidr_blocks       = [data.aws_vpc.vpc.cidr_block]
}

resource "aws_security_group_rule" "sap_application_tcp40080-40099_in" {
  count             = var.enabled ? 1 : 0
  security_group_id = aws_security_group.sap_application.*.id[0]
  type              = "ingress"
  from_port         = "40080"
  to_port           = "40099"
  protocol          = "tcp"
  cidr_blocks       = [data.aws_vpc.vpc.cidr_block]
}

resource "aws_security_group_rule" "sap_application_tcp4237_in" {
  count             = var.enabled ? 1 : 0
  security_group_id = aws_security_group.sap_application.*.id[0]
  type              = "ingress"
  from_port         = "4237"
  to_port           = "4237"
  protocol          = "tcp"
  cidr_blocks       = [data.aws_vpc.vpc.cidr_block]
}

resource "aws_security_group_rule" "sap_application_tcp2049_in" {
  count                    = var.enabled ? 1 : 0
  security_group_id        = aws_security_group.sap_application.*.id[0]
  type                     = "ingress"
  from_port                = "2049"
  to_port                  = "2049"
  protocol                 = "tcp"
  source_security_group_id = var.efs_security_group_id != "" ? var.efs_security_group_id : aws_security_group.sap_application.*.id[0]
}