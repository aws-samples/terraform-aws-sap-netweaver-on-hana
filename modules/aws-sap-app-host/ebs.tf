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

resource "aws_ebs_volume" "xvdf_volume" {
  availability_zone = element(module.instance.availability_zone, count.index)
  size              = 50
  type              = "gp2"
  kms_key_id        = var.kms_key_arn
  encrypted         = true
  lifecycle {
    ignore_changes = [kms_key_id, encrypted]
  }
  count = var.enabled ? var.instance_count : 0

  tags = merge(
    module.tags.values,
  tomap({ "Name" = "${module.tags.values["Name"]}-app_usr_sap" }))
}

resource "aws_volume_attachment" "ebs_attach_xvdf" {
  device_name = "/dev/xvdf"
  count       = var.enabled ? var.instance_count : 0
  volume_id   = aws_ebs_volume.xvdf_volume.*.id[count.index]
  instance_id = module.instance.instance_id[count.index]
}

resource "aws_ebs_volume" "xvdg_volume" {
  availability_zone = element(module.instance.availability_zone, count.index)
  size              = 50
  type              = "gp2"
  kms_key_id        = var.kms_key_arn
  encrypted         = true
  lifecycle {
    ignore_changes = [kms_key_id, encrypted]
  }
  count = var.enabled ? var.instance_count : 0

  tags = merge(
    module.tags.values,
  tomap({ "Name" = "${module.tags.values["Name"]}-app_swap" }))
}

resource "aws_volume_attachment" "ebs_attach_xvdg" {
  device_name = "/dev/xvdg"
  count       = var.enabled ? var.instance_count : 0
  volume_id   = aws_ebs_volume.xvdg_volume.*.id[count.index]
  instance_id = module.instance.instance_id[count.index]
}