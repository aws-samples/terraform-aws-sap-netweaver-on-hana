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
  hana_data_size         = var.hana_disks_data_storage_type == "gp2" ? var.hana_disks_data_gp2[var.instance_type].disk_size : (var.hana_disks_data_storage_type == "io1" ? var.hana_disks_data_io1[var.instance_type].disk_size : 0)
  hana_data_disks_number = var.hana_disks_data_storage_type == "gp2" ? var.hana_disks_data_gp2[var.instance_type].disk_nb : (var.hana_disks_data_gp2 == "io1" ? var.hana_disks_data_gp2[var.instance_type].disk_nb : 0)
  hana_log_size          = var.hana_disks_logs_storage_type == "gp2" ? var.hana_disks_logs_gp2[var.instance_type].disk_size : (var.hana_disks_logs_storage_type == "io1" ? var.hana_disks_logs_io1[var.instance_type].disk_size : 0)
  hana_log_disks_number  = var.hana_disks_logs_storage_type == "gp2" ? var.hana_disks_logs_gp2[var.instance_type].disk_nb : (var.hana_disks_logs_storage_type == "io1" ? var.hana_disks_logs_io1[var.instance_type].disk_nb : 0)
  data_volume_names      = "${formatlist("%s", null_resource.data_volume_names_list.*.triggers.data_volume_name)}"
  log_volume_names       = "${formatlist("%s", null_resource.log_volume_names_list.*.triggers.log_volume_name)}"
}

resource "null_resource" "data_volume_names_list" {
  count = var.enabled ? local.hana_data_disks_number : 0

  triggers = {
    data_volume_name = count.index == 0 ? "/dev/xvdf" : count.index == 1 ? "/dev/xvdg" : count.index == 2 ? "/dev/xvdh" : count.index == 3 ? "/dev/xvdi" : count.index == 4 ? "/dev/xvdj" : count.index == 5 ? "/dev/xvdk" : count.index == 6 ? "/dev/xvdl" : ""
  }
}

resource "null_resource" "log_volume_names_list" {
  count = var.enabled ? local.hana_log_disks_number : 0

  triggers = {
    log_volume_name = count.index == 0 ? "/dev/xvdm" : count.index == 1 ? "/dev/xvdn" : ""
  }
}

# Hana Disks for SHARED volume (/dev/sdl)
resource "aws_ebs_volume" "xvdo_volume" {
  availability_zone = element(module.instance.availability_zone, count.index)
  size              = var.hana_disks_shared_size
  type              = var.hana_disks_shared_storage_type
  kms_key_id        = var.kms_key_arn
  encrypted         = var.kms_key_arn != "" ? true : false
  lifecycle {
    ignore_changes = [kms_key_id, encrypted]
  }
  count = var.enabled ? (! var.is_scale_out ? var.instance_count : 0) : 0
  tags = merge(
    module.tags.values,
  tomap({ "Name" = "${module.tags.values["Name"]}-hana_shared" }))
}

resource "aws_volume_attachment" "ebs_attach_xvdo" {
  device_name = "/dev/xvdo"
  count       = var.enabled ? var.instance_count : 0
  volume_id   = aws_ebs_volume.xvdo_volume.*.id[count.index]
  instance_id = module.instance.instance_id[count.index]
}

# Hana Disks for DATA volumes
resource "aws_ebs_volume" "data_volumes" {
  availability_zone = element(module.instance.availability_zone, floor(count.index / local.hana_data_disks_number))
  size              = local.hana_data_size
  type              = var.hana_disks_data_storage_type
  encrypted         = var.kms_key_arn != "" ? true : false
  kms_key_id        = var.kms_key_arn
  lifecycle {
    ignore_changes = [kms_key_id, encrypted]
  }
  count = var.enabled ? var.instance_count * local.hana_data_disks_number : 0
  tags = merge(
    module.tags.values,
  tomap({ "Name" = "${module.tags.values["Name"]}-hana_data-${count.index}" }))
}

resource "aws_volume_attachment" "ebs_attach_data_volumes" {
  device_name = local.data_volume_names[count.index % local.hana_data_disks_number]
  count       = var.enabled ? var.instance_count * local.hana_data_disks_number : 0
  volume_id   = aws_ebs_volume.data_volumes.*.id[count.index]
  instance_id = module.instance.instance_id[floor(count.index / local.hana_data_disks_number)]
}


# Hana Disks for LOG volumes
resource "aws_ebs_volume" "log_volumes" {
  availability_zone = element(module.instance.availability_zone, floor(count.index / local.hana_log_disks_number))
  size              = local.hana_log_size
  type              = var.hana_disks_logs_storage_type
  encrypted         = var.kms_key_arn != "" ? true : false
  kms_key_id        = var.kms_key_arn
  lifecycle {
    ignore_changes = [kms_key_id, encrypted]
  }
  count = var.enabled ? var.instance_count * local.hana_log_disks_number : 0
  tags = merge(
    module.tags.values,
  tomap({ "Name" = "${module.tags.values["Name"]}-hana_log-${count.index}" }))
}

resource "aws_volume_attachment" "ebs_attach_log_volumes" {
  device_name = local.log_volume_names[count.index % local.hana_log_disks_number]
  count       = var.enabled ? var.instance_count * local.hana_log_disks_number : 0
  volume_id   = aws_ebs_volume.log_volumes.*.id[count.index]
  instance_id = module.instance.instance_id[floor(count.index / local.hana_log_disks_number)]

}

# Hana Disk for BACKUP volume (/dev/xvdp)
resource "aws_ebs_volume" "backup_volumes" {
  availability_zone = element(module.instance.availability_zone, count.index)
  # Assumption that locally we will retain 1 backup on the local EBS Volume
  size       = local.hana_data_size * 2 * local.hana_data_disks_number
  type       = var.hana_disks_backup_storage_type
  kms_key_id = var.kms_key_arn
  encrypted  = var.kms_key_arn != "" ? true : false
  lifecycle {
    ignore_changes = [kms_key_id, encrypted]
  }
  count = var.enabled ? var.instance_count : 0
  tags = merge(
    module.tags.values,
  tomap({ "Name" = "${module.tags.values["Name"]}-hana_backup" }))
}

resource "aws_volume_attachment" "ebs_attach_backup_volumes" {
  device_name = "/dev/xvdp"
  count       = var.enabled ? var.instance_count : 0
  volume_id   = aws_ebs_volume.backup_volumes.*.id[count.index]
  instance_id = module.instance.instance_id[count.index]
}

# Hana Disk for USR/SAP volume (/dev/xvdq)
resource "aws_ebs_volume" "usr_sap_volumes" {
  availability_zone = element(module.instance.availability_zone, count.index)
  size              = var.hana_disks_usr_sap_storage_size
  type              = var.hana_disks_usr_sap_storage_type
  kms_key_id        = var.kms_key_arn
  encrypted         = var.kms_key_arn != "" ? true : false
  lifecycle {
    ignore_changes = [kms_key_id, encrypted]
  }
  count = var.enabled ? var.instance_count : 0
  tags = merge(
    module.tags.values,
  tomap({ "Name" = "${module.tags.values["Name"]}-hana_usr_sap" }))
}

resource "aws_volume_attachment" "ebs_attach_xvdq" {
  device_name = "/dev/xvdq"
  count       = var.enabled ? var.instance_count : 0
  volume_id   = aws_ebs_volume.usr_sap_volumes.*.id[count.index]
  instance_id = module.instance.instance_id[count.index]
}

# Hana Disk for SWAP volume (/dev/xvdr)
resource "aws_ebs_volume" "xvdr_volume" {
  availability_zone = element(module.instance.availability_zone, count.index)
  size              = 50
  type              = "gp2"
  kms_key_id        = var.kms_key_arn
  encrypted         = var.kms_key_arn != "" ? true : false
  lifecycle {
    ignore_changes = [kms_key_id, encrypted]
  }
  count = var.enabled ? var.instance_count : 0

  tags = merge(
    module.tags.values,
  tomap({ "Name" = "${module.tags.values["Name"]}-app_swap" }))
}

resource "aws_volume_attachment" "ebs_attach_xvdr" {
  device_name = "/dev/xvdr"
  count       = var.enabled ? var.instance_count : 0
  volume_id   = aws_ebs_volume.xvdr_volume.*.id[count.index]
  instance_id = module.instance.instance_id[count.index]
}