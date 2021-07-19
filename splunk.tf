

resource "aws_instance" "splunk_ent" {
  ami                    = var.aws_ami_id == "" ? data.aws_ami.splunk_ent.id : var.aws_ami_id
  instance_type          = var.splunk_server_instance_type
  key_name               = var.aws_key_pair_name
  subnet_id              = aws_subnet.splunk_subnet_a.id
  private_ip              = "172.31.54.11"
  vpc_security_group_ids = [aws_security_group.splunk_ent.id]
  ebs_optimized          = true

  root_block_device {
    delete_on_termination = true
    volume_size           = 100
    volume_type           = "gp2"
  }

  tags = merge(
    local.common_tags,
    {
      "Name" = "splunk-ent-${random_id.random.hex}"
    }
  )

  connection {
    user        = var.aws_ubuntu_image_user
    private_key = file(var.aws_key_pair_file)
    host = self.public_ip
  }


  provisioner "file" {
    destination = "/tmp/ssl_cert"
    content = var.splunk_custom_ssl_cert_chain
  }

  provisioner "file" {
    destination = "/tmp/ssl_key"
    content = var.splunk_custom_ssl_private_key
  }

  
  provisioner "local-exec" {
    // Clean up local known_hosts in case we get a re-used public IP
    command = "ssh-keygen -R ${aws_instance.splunk_ent.public_ip}"
  }

  provisioner "local-exec" {
    // Write ssh key for Automate server to local known_hosts so we can scp automate-credentials.toml in data.external.a2_secrets
    command = "ssh-keyscan -t ecdsa ${aws_instance.splunk_ent.public_ip} >> ~/.ssh/known_hosts"
  }

  provisioner "file" {
    content     = templatefile("${path.module}/templates/linux_node_user_data.sh.tpl", { splunk_password = var.splunk_password, load_awscodecommit = var.load_awscodecommit})
    destination = "/tmp/linux_node_user_data.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "bash /tmp/linux_node_user_data.sh"
    ]
  }

  provisioner "remote-exec" {
    inline = [
      "sudo reboot"
    ]
    on_failure = "continue"
  }

}

