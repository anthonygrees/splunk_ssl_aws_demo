terraform {
  required_version = "~> 0.12.24" // Terraform frequently puts breaking changes into minor and patch version releases. _Always_ hard pin to the latest known and tested working version. Do not trust semantic versioning.
}

provider "aws" {
  region                  = var.aws_region
  profile                 = var.aws_profile
  shared_credentials_file = var.aws_credentials_file
}

provider "aws" {
  # us-east-1 instance
  region = "us-east-1"
  alias = "use1"
}

locals {
  common_tags = {
    X-Dept        = "${var.tag_dept}"
    X-Customer    = "${var.tag_customer}"
    X-Project     = "${var.tag_project}"
    X-Application = "${var.tag_application}"
    X-Contact     = "${var.tag_contact}"
    X-TTL         = "${var.tag_ttl}"
  }
}

resource "random_id" "random" {
  byte_length = 4
}

////////////////////////////////
// Instance Data

data "aws_ami" "splunk_ent" {
  most_recent = true
  owners      = ["099720109477"] # Canonical
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}