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
  count = var.enabled ? 1 : 0

  name   = "${module.tags.values["Name"]}-sap-sg"
  vpc_id = var.vpc_id

  lifecycle {
    ignore_changes        = [description]
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "sap_application_https_in" {
  count = var.enabled ? 1 : 0

  security_group_id = aws_security_group.sap_application.*.id[0]
  # security_group_id = "${element(aws_security_group.sap_application.*.id, 0)}"
  type        = "ingress"
  from_port   = "443"
  to_port     = "443"
  protocol    = "tcp"
  cidr_blocks = concat([data.aws_vpc.vpc.cidr_block], var.customer_cidr_blocks)
}

resource "aws_security_group_rule" "sap_application_tcp1128-1129_in" {
  count = var.enabled ? 1 : 0

  security_group_id = aws_security_group.sap_application.*.id[0]
  type              = "ingress"
  from_port         = "1128"
  to_port           = "1129"
  protocol          = "tcp"
  cidr_blocks       = concat([data.aws_vpc.vpc.cidr_block], var.customer_cidr_blocks)
}

resource "aws_security_group_rule" "sap_application_tcp50013-50015_in" {
  count = var.enabled ? 1 : 0

  security_group_id = aws_security_group.sap_application.*.id[0]
  type              = "ingress"
  from_port         = "50013"
  to_port           = "50015"
  protocol          = "tcp"
  cidr_blocks       = concat([data.aws_vpc.vpc.cidr_block], var.customer_cidr_blocks)
}

resource "aws_security_group_rule" "sap_application_tcp30013-30015_in" {
  count = var.enabled ? 1 : 0

  security_group_id = aws_security_group.sap_application.*.id[0]
  type              = "ingress"
  from_port         = "30013"
  to_port           = "30015"
  protocol          = "tcp"
  cidr_blocks       = concat([data.aws_vpc.vpc.cidr_block], var.customer_cidr_blocks)
}