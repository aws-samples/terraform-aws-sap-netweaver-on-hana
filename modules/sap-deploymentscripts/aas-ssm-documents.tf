module "download_aas_software" {
  source = "../../../aws/systems-manager/documents"

  command_name    = "${var.application_name}-download-aas-software"
  automation_type = "Command"
  path_to_yaml    = file("${path.module}/scripts/module-automations/aas/commands/sap-aas-download-media.yaml")

  tags = module.tags.values
}

module "execute_aas_installation" {
  source = "../../../aws/systems-manager/documents"

  command_name    = "${var.application_name}-execute-aas-installation"
  automation_type = "Command"
  path_to_yaml = templatefile("${path.module}/scripts/module-automations/aas/commands/sap-aas-execute-installation.yaml", {
    DNSPrivateZoneName = var.dns_zone_name
  })

  tags = module.tags.values
}


module "install_aas" {
  source = "../../../aws/systems-manager/documents"

  command_name    = "${var.application_name}-install-aas-master-document"
  automation_type = "Automation"
  path_to_yaml = templatefile("${path.module}/scripts/module-automations/aas/sap-aas-installation.yaml", {
    MasterPasswordParameterName     = module.system_user_password.parameter.name,
    DNSPrivateZoneName              = var.dns_zone_name,
    InstallationMediaBucket         = var.binaries_folder == "" ? var.binaries_bucket_name : "${var.binaries_bucket_name}/${var.binaries_folder}",
    CloudWatchLogGroupName          = module.sap_setup_logs_group.name,
    DbInstanceId                    = length(var.hana_instance_ids) > 0 ? tostring(var.hana_instance_ids[0]) : "",
    AscsInstanceId                  = length(var.ascs_instance_ids) > 0 ? tostring(var.ascs_instance_ids[0]) : "",
    AddToHostsDocumentName          = module.add_to_hosts.document.name,
    DownloadSoftwareDocumentName    = module.download_aas_software.document.name,
    ExecuteInstallationDocumentName = module.execute_aas_installation.document.name,
    DNSPrivateZoneName              = var.dns_zone_name,
    AasProductId                    = "NW_DI:${var.product}"
  })

  tags = module.tags.values
}