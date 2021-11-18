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

# This is a calculations based on SAP on AWS best practices
# https://docs.aws.amazon.com/quickstart/latest/sap-hana/storage.html
variable "hana_disks_data_gp2" {
  type = map(object({ disk_nb = number, disk_size = number }))
  default = {
    "r4.2xlarge" = {
      disk_nb   = 3,
      disk_size = 225
    },
    "x1e.xlarge" = {
      disk_nb   = 3,
      disk_size = 225
    },
    "r5.4xlarge" = {
      disk_nb   = 3,
      disk_size = 225
    },
    "r5.8xlarge" = {
      disk_nb   = 3,
      disk_size = 225
    },
    "x1e.2xlarge" = {
      disk_nb   = 3,
      disk_size = 225
    },
    "r5.12xlarge" = {
      disk_nb   = 3,
      disk_size = 225
    },
    "x1e.4xlarge" = {
      disk_nb   = 3,
      disk_size = 225
    },
    "r5.24xlarge" = {
      disk_nb   = 3,
      disk_size = 400
    },
    "x1.16xlarge" = {
      disk_nb   = 3,
      disk_size = 400
    },
    "x1.32xlarge" = {
      disk_nb   = 3,
      disk_size = 800
    },
    "x1e.32xlarge" = {
      disk_nb   = 3,
      disk_size = 1600
    },
    "u-6tb1.metal" = {
      disk_nb   = 3,
      disk_size = 2400
    },
    "u-9tb1.metal" = {
      disk_nb   = 3,
      disk_size = 3600
    },
    "u-12tb1.metal" = {
      disk_nb   = 3,
      disk_size = 4800
    },
    "u-18tb1.metal" = {
      disk_nb   = 6,
      disk_size = 3600
    },
    "u-24tb1.metal" = {
      disk_nb   = 6,
      disk_size = 4800
    }
  }
}

variable "hana_disks_logs_gp2" {
  type = map(object({ disk_nb = number, disk_size = number }))
  default = {
    "r4.2xlarge" = {
      disk_nb   = 2,
      disk_size = 175
    },
    "x1e.xlarge" = {
      disk_nb   = 2,
      disk_size = 175
    },
    "r5.4xlarge" = {
      disk_nb   = 2,
      disk_size = 175
    },
    "r5.8xlarge" = {
      disk_nb   = 2,
      disk_size = 175
    },
    "x1e.2xlarge" = {
      disk_nb   = 2,
      disk_size = 175
    },
    "r5.12xlarge" = {
      disk_nb   = 2,
      disk_size = 300
    },
    "x1e.4xlarge" = {
      disk_nb   = 2,
      disk_size = 300
    },
    "r5.24xlarge" = {
      disk_nb   = 2,
      disk_size = 300
    },
    "x1.16xlarge" = {
      disk_nb   = 2,
      disk_size = 300
    },
    "x1.32xlarge" = {
      disk_nb   = 2,
      disk_size = 300
    },
    "x1e.32xlarge" = {
      disk_nb   = 2,
      disk_size = 300
    },
    "u-6tb1.metal" = {
      disk_nb   = 2,
      disk_size = 300
    },
    "u-9tb1.metal" = {
      disk_nb   = 2,
      disk_size = 300
    },
    "u-12tb1.metal" = {
      disk_nb   = 2,
      disk_size = 300
    },
    "u-18tb1.metal" = {
      disk_nb   = 2,
      disk_size = 300
    },
    "u-24tb1.metal" = {
      disk_nb   = 2,
      disk_size = 300
    }
  }
}

variable "hana_disks_data_io1" {
  type = map(object({ disk_nb = number, disk_size = number }))
  default = {
    "r4.2xlarge" = {
      disk_nb   = 1,
      disk_size = 300
    },
    "x1e.xlarge" = {
      disk_nb   = 1,
      disk_size = 300
    },
    "r5.8xlarge" = {
      disk_nb   = 1,
      disk_size = 300
    },
    "r5.4xlarge" = {
      disk_nb   = 1,
      disk_size = 300
    },
    "x1e.2xlarge" = {
      disk_nb   = 1,
      disk_size = 300
    },
    "r5.12xlarge" = {
      disk_nb   = 1,
      disk_size = 600
    },
    "x1e.4xlarge" = {
      disk_nb   = 1,
      disk_size = 600
    },
    "r5.24xlarge" = {
      disk_nb   = 1,
      disk_size = 1200
    },
    "x1.16xlarge" = {
      disk_nb   = 1,
      disk_size = 1200
    },
    "x1.32xlarge" = {
      disk_nb   = 3,
      disk_size = 800
    },
    "x1e.32xlarge" = {
      disk_nb   = 3,
      disk_size = 1600
    },
    "u-6tb1.metal" = {
      disk_nb   = 3,
      disk_size = 2400
    },
    "u-9tb1.metal" = {
      disk_nb   = 3,
      disk_size = 3600
    },
    "u-12tb1.metal" = {
      disk_nb   = 3,
      disk_size = 4800
    },
    "u-18tb1.metal" = {
      disk_nb   = 6,
      disk_size = 3600
    },
    "u-24tb1.metal" = {
      disk_nb   = 6,
      disk_size = 4800
    }
  }
}

variable "hana_disks_logs_io1" {
  type = map(object({ disk_nb = number, disk_size = number }))
  default = {
    "r4.2xlarge" = {
      disk_nb   = 1,
      disk_size = 260
    },
    "x1e.xlarge" = {
      disk_nb   = 1,
      disk_size = 260
    },
    "r5.4xlarge" = {
      disk_nb   = 1,
      disk_size = 260
    },
    "x1e.2xlarge" = {
      disk_nb   = 1,
      disk_size = 260
    },
    "r5.12xlarge" = {
      disk_nb   = 1,
      disk_size = 260
    },
    "x1e.4xlarge" = {
      disk_nb   = 1,
      disk_size = 260
    },
    "r5.24xlarge" = {
      disk_nb   = 1,
      disk_size = 525
    },
    "x1.16xlarge" = {
      disk_nb   = 1,
      disk_size = 525
    },
    "x1.32xlarge" = {
      disk_nb   = 1,
      disk_size = 525
    },
    "x1e.32xlarge" = {
      disk_nb   = 1,
      disk_size = 525
    },
    "u-6tb1.metal" = {
      disk_nb   = 1,
      disk_size = 525
    },
    "u-9tb1.metal" = {
      disk_nb   = 1,
      disk_size = 525
    },
    "u-12tb1.metal" = {
      disk_nb   = 1,
      disk_size = 525
    },
    "u-18tb1.metal" = {
      disk_nb   = 1,
      disk_size = 525
    },
    "u-24tb1.metal" = {
      disk_nb   = 1,
      disk_size = 525
    }
  }
}