module "download_pas_software" {
  source = "../../../aws/systems-manager/documents"

  command_name    = "${var.application_name}-download-pas-software"
  automation_type = "Command"
  path_to_yaml    = file("${path.module}/scripts/module-automations/pas/commands/sap-pas-download-media.yaml")

  tags = module.tags.values
}

module "execute_pas_installation" {
  source = "../../../aws/systems-manager/documents"

  command_name    = "${var.app_code}-${var.application_name}-execute-pas-installation"
  automation_type = "Command"
  path_to_yaml = templatefile("${path.module}/scripts/module-automations/pas/commands/sap-pas-execute-installation.yaml", {
    DNSPrivateZoneName = var.dns_zone_name
  })

  tags = module.tags.values
}


module "install_pas" {
  source = "../../../aws/systems-manager/documents"

  command_name    = "${var.application_name}-install-pas-master-document"
  automation_type = "Automation"
  path_to_yaml = templatefile("${path.module}/scripts/module-automations/pas/sap-pas-installation.yaml", {
    MasterPasswordParameterName     = module.system_user_password.parameter.name,
    DNSPrivateZoneName              = var.dns_zone_name,
    InstallationMediaBucket         = var.binaries_folder == "" ? var.binaries_bucket_name : "${var.binaries_bucket_name}/${var.binaries_folder}",
    CloudWatchLogGroupName          = module.sap_setup_logs_group.name,
    EfsFileSystemId                 = var.efs_sapmnt,
    DbInstanceId                    = length(var.hana_instance_ids) > 0 ? tostring(var.hana_instance_ids[0]) : "",
    AscsInstanceId                  = length(var.ascs_instance_ids) > 0 ? tostring(var.ascs_instance_ids[0]) : "",
    AddToHostsDocumentName          = module.add_to_hosts.document.name,
    DownloadSoftwareDocumentName    = module.download_pas_software.document.name,
    ExecuteInstallationDocumentName = module.execute_pas_installation.document.name,
    PasProductId                    = "NW_ABAP_CI:${var.product}",
    DNSPrivateZoneName              = var.dns_zone_name,
    DbProductId                     = "NW_ABAP_DB:${var.product}"
  })

  tags = module.tags.values
}