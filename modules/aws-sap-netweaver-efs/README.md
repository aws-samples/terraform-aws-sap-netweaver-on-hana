# AWS SAP HANA Infrastructure Terraform module

Terraform module which creates an Amazon Elastic File System (EFS). Amazon EFS – Amazon Elastic File System (Amazon EFS) provides a shared file system that can be attached across various EC2 hosts. This file storage can be particularly useful for SAP scale-out instances, where shared files like /usr/sap/trans or /sapmnt/<sid> need to be mounted