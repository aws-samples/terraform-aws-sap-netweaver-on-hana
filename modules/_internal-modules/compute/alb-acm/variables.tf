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

# base alb vars
variable "subnets" {
  type = list(string)
}

variable "security_groups" {
  type = list(string)
}

variable "platform" {}
variable "service" {}
variable "programme" {}

# alb listener vars
variable "ssl_policy" {}

# alb target group vars
variable "vpc_id" {}

variable "health_check_path" {}
variable "internal" {}
variable "load_balancer_type" {}
variable "enable_cross_zone_load_balancing" {}
variable "health_check_port" {}
variable "health_check_protocol" {}
variable "health_check_healthy_threshold" {}
variable "health_check_unhealthy_threshold" {}
variable "health_check_timeout" {}
variable "health_check_interval" {}
variable "health_check_matcher" {}
variable "deregistration_delay" {}
variable "target_type" {}
variable "stickiness_type" {}
variable "stickiness_cookie_duration" {}
variable "stickiness_enabled" {}

# ssl cert vars

variable "certificate_arn" {}

variable "enabled" {
  default = false
}
