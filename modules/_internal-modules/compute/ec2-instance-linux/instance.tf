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

resource "aws_instance" "linux-server" {
  ami                    = var.ami
  count                  = var.enabled == true ? var.instance_count : 0
  instance_type          = var.instance_type
  subnet_id              = flatten(var.subnet_ids)[count.index % length(var.subnet_ids)]
  vpc_security_group_ids = var.vpc_security_group_ids
  user_data              = var.user_data != "" ? var.user_data : templatefile("${path.module}/default-user-data.sh", {})
  key_name               = var.ssh_key
  ebs_optimized          = var.ebs_optimized
  source_dest_check      = var.source_dest_check
  iam_instance_profile   = aws_iam_instance_profile.ec2_instance_profile[0].name
  monitoring             = true

  lifecycle {
    ignore_changes = [user_data, root_block_device, ami]
  }

  tags = merge(var.tags, count.index == 0 ?
    tomap({ "Name" = "${var.tags["Name"]}-primary", "Hostname" = var.hostnames[0] }) :
    tomap({ "Name" = "${var.tags["Name"]}-additional-${count.index + 1}", "Hostname" = var.hostnames[count.index] })
  )

  root_block_device {
    # device_name = count.index == 0 ? "${var.tags["Name"]}-primary-root-volume" : "${var.tags["Name"]}-additional-${count.index + 1}-root-volume"
    volume_size = var.root_volume_size
    volume_type = var.volume_type
    encrypted   = true
    kms_key_id  = var.kms_key_arn
  }
}