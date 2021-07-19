resource "aws_security_group" "splunk_ent" {
  name   = "splunk-ent-automate-sg-${random_id.random.hex}"
  vpc_id = aws_vpc.splunk_vpc.id

  tags = merge(
    local.common_tags,
    {
      "Name" = "splunk-ent-automate-sg-${random_id.random.hex}"
    }
  )
}

resource "aws_security_group_rule" "splunk_ent_ingress_allow_22_tcp" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.splunk_ent.id
}

# Splunk Rules
resource "aws_security_group_rule" "splunk_ent_ingress_allow_80_tcp" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.splunk_ent.id
}

resource "aws_security_group_rule" "splunk_ent_ingress_allow_443_tcp" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.splunk_ent.id
}

# Splunk Kv Store
resource "aws_security_group_rule" "splunk_ent_ingress_allow_8191_tcp" {
  type                     = "ingress"
  from_port                = 8191
  to_port                  = 8191
  protocol                 = "tcp"
  security_group_id        = aws_security_group.splunk_ent.id
  source_security_group_id = aws_security_group.splunk_ent.id
}

# Splunk App Svr
resource "aws_security_group_rule" "splunk_ent_ingress_allow_8065_tcp" {
  type                     = "ingress"
  from_port                = 8065
  to_port                  = 8065
  protocol                 = "tcp"
  security_group_id        = aws_security_group.splunk_ent.id
  source_security_group_id = aws_security_group.splunk_ent.id
}

resource "aws_security_group_rule" "splunk_ent_egress_allow_all" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.splunk_ent.id
}

# Splunk Mgmt Port
resource "aws_security_group_rule" "splunk_ent_ingress_allow_8089_tcp" {
  type              = "ingress"
  from_port         = 8089
  to_port           = 8089
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.splunk_ent.id
}

# Splunk Web UI
resource "aws_security_group_rule" "splunk_ent_ingress_allow_8000_tcp" {
  type              = "ingress"
  from_port         = 8000
  to_port           = 8000
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.splunk_ent.id
}
# Splunk H
resource "aws_security_group_rule" "splunk_ent_ingress_allow_8080_tcp" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.splunk_ent.id
}

# Splunk HEC
resource "aws_security_group_rule" "splunk_ent_ingress_allow_8088_tcp" {
  type              = "ingress"
  from_port         = 8088
  to_port           = 8088
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.splunk_ent.id
}
