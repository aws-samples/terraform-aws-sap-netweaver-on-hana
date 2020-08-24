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


data "aws_route53_zone" "dns_zone" {
  name         = var.dns_zone_name
  private_zone = true
}
data "aws_vpc" "vpc" {
  id = var.vpc_id
}

data "template_file" "init" {
  /*template = "${file("user_data")}"*/
  template = <<EOF
#!/bin/bash
sudo chmod 666 /etc/hosts
sudo cp /etc/hosts /etc/hosts.tmp
sudo awk '$1==s{$0=$0 OFS alias}1' s=127.0.0.1 alias=$HOSTNAME /etc/hosts.tmp >/etc/hosts
sudo rm /etc/hosts.tmp
sudo chmod 644 /etc/hosts
sudo passwd --delete aws_install
EOF
}
