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
module "prepare_logs" {
  source = "../_internal-modules/systems-manager/documents"

  command_name    = "${var.application_name}-prepare-sap-installation-logs"
  automation_type = "Command"
  path_to_yaml    = file("${path.module}/scripts/module-automations/shared/commands/sap-prepare-logs.yaml")

  tags = module.tags.values
}

module "set_hostname" {
  source = "../_internal-modules/systems-manager/documents"

  command_name    = "${var.application_name}-set-hostname"
  automation_type = "Command"
  path_to_yaml    = file("${path.module}/scripts/module-automations/shared/commands/sap-hostname.yaml")

  tags = module.tags.values
}

module "install_packages" {
  source = "../_internal-modules/systems-manager/documents"

  command_name    = "${var.application_name}-install-sap-packages"
  automation_type = "Command"
  path_to_yaml    = file("${path.module}/scripts/module-automations/shared/commands/sap-packages.yaml")

  tags = module.tags.values
}

module "install_aws_data_provider" {
  source = "../_internal-modules/systems-manager/documents"

  command_name    = "${var.application_name}-install-sap-aws-data-provider"
  automation_type = "Command"
  path_to_yaml    = file("${path.module}/scripts/module-automations/shared/commands/sap-install-aws-data-provider.yaml")

  tags = module.tags.values
}


module "add_to_hosts" {
  source = "../_internal-modules/systems-manager/documents"

  command_name    = "${var.application_name}-add_to_hosts"
  automation_type = "Command"
  path_to_yaml    = file("${path.module}/scripts/module-automations/shared/commands/sap-add-to-hosts.yaml")

  tags = module.tags.values
}
