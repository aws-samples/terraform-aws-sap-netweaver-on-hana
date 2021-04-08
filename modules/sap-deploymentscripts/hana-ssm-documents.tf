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
module "set_hana_parameters" {
  source = "../_internal-modules/systems-manager/documents"

  command_name    = "${var.application_name}-set-sap-hana-parameters"
  automation_type = "Command"
  path_to_yaml    = file("${path.module}/scripts/module-automations/hana/commands/sap-hana-parameters.yaml")

  tags = module.tags.values
}


module "mount_hana_disks" {
  source = "../_internal-modules/systems-manager/documents"

  command_name    = "${var.application_name}-mount-hana-disks"
  automation_type = "Command"
  path_to_yaml    = file("${path.module}/scripts/module-automations/hana/commands/sap-hana-disks.yaml")

  tags = module.tags.values
}

module "prepare_hana_backup" {
  source = "../_internal-modules/systems-manager/documents"

  command_name    = "${var.application_name}-prepare-hana-backup"
  automation_type = "Command"
  path_to_yaml    = file("${path.module}/scripts/module-automations/hana/commands/sap-hana-backup-folders.yaml")

  tags = module.tags.values
}

module "download_hana_software" {
  source = "../_internal-modules/systems-manager/documents"

  command_name    = "${var.application_name}-download-hana-software"
  automation_type = "Command"
  path_to_yaml    = file("${path.module}/scripts/module-automations/hana/commands/sap-hana-download-media.yaml")

  tags = module.tags.values
}

module "execute_hana_installation" {
  source = "../_internal-modules/systems-manager/documents"

  command_name    = "${var.application_name}-execute-hana-installation"
  automation_type = "Command"
  path_to_yaml    = file("${path.module}/scripts/module-automations/hana/commands/sap-hana-execute-installation.yaml")

  tags = module.tags.values
}

module "hana_post_installation" {
  source = "../_internal-modules/systems-manager/documents"

  command_name    = "${var.application_name}-hana-post-installation"
  automation_type = "Command"
  path_to_yaml    = file("${path.module}/scripts/module-automations/hana/commands/sap-hana-post-installation.yaml")

  tags = module.tags.values
}

module "bootstrap_hana_instance" {
  source = "../_internal-modules/systems-manager/documents"

  command_name    = "${var.application_name}-bootstrap-hana-instance"
  automation_type = "Automation"
  path_to_yaml = templatefile("${path.module}/scripts/module-automations/hana/sap-hana-bootstrap-instance.yaml", {
    MasterPasswordParameterName        = module.system_user_password.parameter.name,
    DNSPrivateZoneName                 = var.dns_zone_name,
    CloudWatchLogGroupName             = module.sap_setup_logs_group.name,
    PrepareLogsDocumentName            = module.prepare_logs.document.name,
    SetHostnameDocumentName            = module.set_hostname.document.name,
    InstallPackagesDocumentName        = module.install_packages.document.name,
    SetParametersDocumentName          = module.set_hana_parameters.document.name,
    MountDisksDocumentName             = module.mount_hana_disks.document.name,
    InstallAwsDataProviderDocumentName = module.install_aws_data_provider.document.name
  })

  tags = module.tags.values
}

module "install_hana" {
  source = "../_internal-modules/systems-manager/documents"

  command_name    = "${var.application_name}-install-hana-master-document"
  automation_type = "Automation"
  path_to_yaml = templatefile("${path.module}/scripts/module-automations/hana/sap-hana-installation.yaml", {
    MasterPasswordParameterName      = module.system_user_password.parameter.name,
    DNSPrivateZoneName               = var.dns_zone_name,
    DefaultBinariesBucket            = var.binaries_folder == "" ? var.binaries_bucket_name : "${var.binaries_bucket_name}/${var.binaries_folder}",
    CloudWatchLogGroupName           = module.sap_setup_logs_group.name,
    PrepareBackupFoldersDocumentName = module.prepare_hana_backup.document.name,
    DownloadSoftwareDocumentName     = module.download_hana_software.document.name,
    ExecuteInstallationDocumentName  = module.execute_hana_installation.document.name
    PostInstallationDocumentName     = module.hana_post_installation.document.name
  })

  tags = module.tags.values
}