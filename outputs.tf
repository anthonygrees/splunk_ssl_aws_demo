
output "load_balancer" {
  value = "${aws_lb.splunk_ent.dns_name}"
}

output "splunk_ent_public_ip" {
  value = "${aws_instance.splunk_ent.public_ip}"
}