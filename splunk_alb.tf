# Load Balancer
resource "aws_lb" "splunk_ent" {
  load_balancer_type = "application"
  name               = "splunk-lb-${random_id.random.hex}" # Only allows hyphens
  internal           = "false"
  security_groups    = [aws_security_group.splunk_ent.id]
  subnets            = [aws_subnet.splunk_subnet_a.id,aws_subnet.splunk_subnet_b.id]

  tags = merge(
    local.common_tags,
    {
      "Name" = "splunk-lb-${random_id.random.hex}"
    }
  )
}

data "aws_acm_certificate" "splunk_ent" {
  domain      = var.splunk_alb_acm_matcher
  statuses    = ["ISSUED"]
  most_recent = true
}

data "aws_route53_zone" "selected" {
  name = var.splunk_alb_r53_matcher
}

resource "aws_route53_record" "splunk_ent" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = var.splunk_hostname
  type    = "CNAME"
  ttl     = "30"
  records = [aws_lb.splunk_ent.dns_name]
}

#
# Splunk Web
#
resource "aws_lb_target_group" "splunk_ent" {
  name     = "splunk-lb-tg-${random_id.random.hex}" # Only allows hyphens
  vpc_id   = aws_vpc.splunk_vpc.id
  port     = "8000"
  protocol = "HTTPS"

  depends_on = [aws_lb.splunk_ent]

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(
    local.common_tags,
    {
      "Name" = "splunk-lb-tg-${random_id.random.hex}"
    }
  )
}

resource "aws_lb_listener" "splunk_ent" {
  load_balancer_arn = aws_lb.splunk_ent.arn
  port              = "443"
  protocol          = "HTTPS"
  certificate_arn   = data.aws_acm_certificate.splunk_ent.arn
  default_action {
    target_group_arn = aws_lb_target_group.splunk_ent.id
    type             = "forward"
  }
}

resource "aws_lb_listener_certificate" "splunk_ent" {
  listener_arn    = aws_lb_listener.splunk_ent.arn
  certificate_arn = data.aws_acm_certificate.splunk_ent.arn
}

resource "aws_lb_target_group_attachment" "splunk_ent" {
  target_group_arn = aws_lb_target_group.splunk_ent.arn
  target_id        = aws_instance.splunk_ent.id
  port             = 8000
}

#
# Splunk HEC
#
resource "aws_lb_target_group" "splunk_ent_hec" {
  name     = "splunk-lb-tg-hec-${random_id.random.hex}" # Only allows hyphens
  vpc_id   = aws_vpc.splunk_vpc.id
  port     = "8088"
  protocol = "HTTPS"

  depends_on = [aws_lb.splunk_ent]

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(
    local.common_tags,
    {
      "Name" = "splunk-lb-tg-hec-${random_id.random.hex}"
    }
  )
}

resource "aws_lb_listener" "splunk_ent_hec" {
  load_balancer_arn = aws_lb.splunk_ent.arn
  port              = "8088"
  protocol          = "HTTPS"
  certificate_arn   = data.aws_acm_certificate.splunk_ent.arn
  default_action {
    target_group_arn = aws_lb_target_group.splunk_ent_hec.id
    type             = "forward"
  }
}

resource "aws_lb_listener_certificate" "splunk_ent_hec" {
  listener_arn    = aws_lb_listener.splunk_ent_hec.arn
  certificate_arn = data.aws_acm_certificate.splunk_ent.arn
}

resource "aws_lb_target_group_attachment" "splunk_ent_hec" {
  target_group_arn = aws_lb_target_group.splunk_ent_hec.arn
  target_id        = aws_instance.splunk_ent.id
  port             = 8088
}

