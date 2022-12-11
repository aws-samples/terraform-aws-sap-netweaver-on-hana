resource "aws_s3_bucket_object" "ascs_template" {
  bucket        = var.binaries_bucket_name
  key           = var.binaries_folder == "" ? "NW75Parameters/ascs.params" : "${var.binaries_folder}/NW75Parameters/ascs.params"
  source        = "${path.module}/scripts/module-automations/sapinst-templates/ascs.params"
  acl           = "bucket-owner-full-control"
  storage_class = "ONEZONE_IA"
  kms_key_id    = var.binaries_key_arn
}

#Pas parameter file template upload
resource "aws_s3_bucket_object" "pas_template" {
  bucket        = var.binaries_bucket_name
  key           = var.binaries_folder == "" ? "NW75Parameters/pas.params" : "${var.binaries_folder}/NW75Parameters/pas.params"
  source        = "${path.module}/scripts/module-automations/sapinst-templates/pas.params"
  storage_class = "ONEZONE_IA"
  acl           = "bucket-owner-full-control"
  kms_key_id    = var.binaries_key_arn
}

#Db instance parameter file upload
resource "aws_s3_bucket_object" "db_template" {
  bucket        = var.binaries_bucket_name
  key           = var.binaries_folder == "" ? "NW75Parameters/db.params" : "${var.binaries_folder}/NW75Parameters/db.params"
  source        = "${path.module}/scripts/module-automations/sapinst-templates/db.params"
  acl           = "bucket-owner-full-control"
  storage_class = "ONEZONE_IA"
  kms_key_id    = var.binaries_key_arn
}

#Aas instance parameter file upload
resource "aws_s3_bucket_object" "aas_template" {
  bucket        = var.binaries_bucket_name
  key           = var.binaries_folder == "" ? "NW75Parameters/aas.params" : "${var.binaries_folder}/NW75Parameters/aas.params"
  source        = "${path.module}/scripts/module-automations/sapinst-templates/aas.params"
  acl           = "bucket-owner-full-control"
  storage_class = "ONEZONE_IA"

  kms_key_id = var.binaries_key_arn
}