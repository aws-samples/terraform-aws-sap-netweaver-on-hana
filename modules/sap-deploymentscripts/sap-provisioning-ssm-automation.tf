#Mother document to trigger them all
module "install_netweaver" {
  source = "../../../aws/systems-manager/documents"

  command_name    = "${var.application_name}-sap-netweaver-installation-pipeline"
  automation_type = "Automation"
  path_to_yaml = templatefile("${path.module}/scripts/sap-netweaver-abap.yaml", {
    CloudWatchLogGroupName              = module.sap_setup_logs_group.name,
    InstallationMediaBucket             = var.binaries_folder == "" ? var.binaries_bucket_name : "${var.binaries_bucket_name}/${var.binaries_folder}",
    EfsFileSystemId                     = var.efs_sapmnt,
    DbInstanceIds                       = length(var.hana_instance_ids) > 0 ? jsonencode(var.hana_instance_ids) : "[]"
    PasInstanceId                       = length(var.as_instance_ids) > 0 ? tostring(var.as_instance_ids[0]) : ""
    AscsInstanceId                      = length(var.ascs_instance_ids) > 0 ? tostring(var.ascs_instance_ids[0]) : "",
    AasInstanceIds                      = length(var.as_instance_ids) > 1 ? jsonencode(slice(var.as_instance_ids, 1, length(var.as_instance_ids))) : "[]"
    BootstrapNetweaverInstancesDocument = module.bootstrap_netweaver_instances.document.name,
    BootstrapHanaInstanceDocument       = module.bootstrap_hana_instance.document.name,
    HanaProvisioningDocument            = module.install_hana.document.name,
    AscsProvisioningDocument            = module.install_ascs.document.name,
    PasProvisioningDocument             = module.install_pas.document.name,
    AasProvisioningDocument             = module.install_aas.document.name,
    DNSPrivateZoneName                  = var.dns_zone_name,
    DbProductId                         = "NW_ABAP_DB:${var.product}",
    PasProductId                        = "NW_ABAP_CI:${var.product}",
    AscsProductId                       = "NW_ABAP_ASCS:${var.product}",
    AasProductId                        = "NW_DI:${var.product}"
  })
  tags = module.tags.values
}