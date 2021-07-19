resource "aws_vpc" "splunk_vpc" {
  cidr_block           = "172.31.0.0/16"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"

  tags = merge(
    local.common_tags,
    {
      "Name" = "splunk-vpc-${random_id.random.hex}"
    }
  )
}

resource "aws_internet_gateway" "splunk_gw" {
  vpc_id = aws_vpc.splunk_vpc.id

  tags = merge(
    local.common_tags,
    {
      "Name" = "splunk-gw-${random_id.random.hex}"
    }
  )
}

resource "aws_route" "splunk_default_route" {
  route_table_id         = aws_vpc.splunk_vpc.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.splunk_gw.id
}

resource "aws_subnet" "splunk_subnet_a" {
  vpc_id                  = aws_vpc.splunk_vpc.id
  cidr_block              = "172.31.54.0/24"
  map_public_ip_on_launch = true
  availability_zone = "${var.aws_region}a"

  tags = merge(
    local.common_tags,
    {
      "Name" = "splunk-subnet-a-${random_id.random.hex}"
    }
  )
}

resource "aws_subnet" "splunk_subnet_b" {
  vpc_id                  = aws_vpc.splunk_vpc.id
  cidr_block              = "172.31.55.0/24"
  map_public_ip_on_launch = true
  availability_zone = "${var.aws_region}b"

  tags = merge(
    local.common_tags,
    {
      "Name" = "splunk-subnet-b-${random_id.random.hex}"
    }
  )
}
