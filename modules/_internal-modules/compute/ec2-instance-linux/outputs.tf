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

output "availability_zone" {
  value = aws_instance.linux-server.*.availability_zone
}

output "private_ip" {
  value = aws_instance.linux-server.*.private_ip
}

output "instance_id" {
  value = aws_instance.linux-server.*.id
}

output "instance_name" {
  value = aws_instance.linux-server.*.tags.Name
}

output "instance_public_ips" {
  value = aws_instance.linux-server.*.public_ip
}

output "network_interface_id" {
  value = aws_instance.linux-server.*.primary_network_interface_id
}

// output "instance_profile" {
//   value = length(aws_iam_instance_profile.ec2_instance_profile.*.name) > 0 ? aws_iam_instance_profile.ec2_instance_profile.*.name[0] : ""
// }