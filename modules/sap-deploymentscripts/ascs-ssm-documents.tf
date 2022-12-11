module "download_ascs_software" {
  source = "../../../aws/systems-manager/documents"

  command_name    = "${var.application_name}-download-ascs-software"
  automation_type = "Command"
  path_to_yaml    = file("${path.module}/scripts/module-automations/ascs/commands/sap-ascs-download-media.yaml")

  tags = module.tags.values
}

module "execute_ascs_installation" {
  source = "../../../aws/systems-manager/documents"

  command_name    = "${var.application_name}-execute-ascs-installation"
  automation_type = "Command"
  path_to_yaml = templatefile("${path.module}/scripts/module-automations/ascs/commands/sap-ascs-execute-installation.yaml", {
    DNSPrivateZoneName = var.dns_zone_name
  })

  tags = module.tags.values
}


module "install_ascs" {
  source = "../../../aws/systems-manager/documents"

  command_name    = "${var.application_name}-install-ascs-master-document"
  automation_type = "Automation"
  path_to_yaml = templatefile("${path.module}/scripts/module-automations/ascs/sap-ascs-installation.yaml", {
    MasterPasswordParameterName     = module.system_user_password.parameter.name,
    DNSPrivateZoneName              = var.dns_zone_name,
    InstallationMediaBucket         = var.binaries_folder == "" ? var.binaries_bucket_name : "${var.binaries_bucket_name}/${var.binaries_folder}",
    AscsProductId                   = "NW_ABAP_ASCS:${var.product}",
    EfsFileSystemId                 = var.efs_sapmnt,
    DbInstanceId                    = length(var.hana_instance_ids) > 0 ? tostring(var.hana_instance_ids[0]) : "",
    CloudWatchLogGroupName          = module.sap_setup_logs_group.name,
    AddToHostsDocumentName          = module.add_to_hosts.document.name,
    DownloadSoftwareDocumentName    = module.download_ascs_software.document.name,
    DNSPrivateZoneName              = var.dns_zone_name,
    ExecuteInstallationDocumentName = module.execute_ascs_installation.document.name,
  })

  tags = module.tags.values
}