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

resource "random_password" "generated_password" {
  length      = var.password_length
  special     = var.enable_special_chars
  count       = var.is_password ? 1 : 0
  min_numeric = 1
}

resource "aws_ssm_parameter" "parameter" {
  name        = "/generic_secret/aws/${lower(var.application_code)}/${lower(var.environment)}/${lower(var.aws_service)}/${lower(replace(var.parameter_short_description, " ", "-"))}"
  description = "${var.parameter_short_description} for ${var.application_name} - ${var.environment}"
  type        = "SecureString"
  value       = var.is_password ? random_password.generated_password[0].result : var.value
  key_id      = var.kms_key_arn
  tags        = merge(var.tags)
}