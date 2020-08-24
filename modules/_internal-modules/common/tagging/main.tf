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
  inputs = {
    environment           = lower(var.environment)
    application_code      = lower(var.application_code)
    application_name      = lower(var.application_name)
    application_owner     = lower(lookup(var.application_owner, var.application_name, "N/A"))
    application_component = lower(var.application_component)
    sid                   = lower(var.sid)
    provisioner           = lower(var.provisioner)
    delimiter             = var.delimiter
  }

  outputs = {
    Name                 = length(local.inputs["application_component"]) == 0 ? "${local.inputs["application_name"]}${local.inputs["delimiter"]}${local.inputs["environment"]}" : "${local.inputs["application_name"]}${local.inputs["delimiter"]}${local.inputs["application_component"]}${local.inputs["delimiter"]}${local.inputs["environment"]}"
    Environment          = local.inputs["environment"]
    AppCode              = local.inputs["application_code"]
    ApplicationName      = local.inputs["application_name"]
    ApplicationOwner     = local.inputs["application_owner"]
    ApplicationComponent = local.inputs["application_component"]
    Sid                  = local.inputs["sid"]
    Provisioner          = local.inputs["provisioner"]
  }
}