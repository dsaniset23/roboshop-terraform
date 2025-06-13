resource "aws_security_group" "sg" {
  name        = "${var.component_name}-${var.env}-sg"
  description = "Allow TCP inbound traffic and all outbound traffic"

  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "TCP"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    from_port        = var.app_port
    to_port          = var.app_port
    protocol         = "TCP"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}

resource "aws_instance" "instance" {
  ami           = data.aws_ami.ami.id
  instance_type = var.instance_type
  vpc_security_group_ids = [aws_security_group.sg.id]
  tags = {
    Name = "${var.component_name}-${var.env}"
  }
}

resource "aws_route53_record" "record" {
  zone_id = var.zone_id //Gave ami_id instead of zoneId
  name    = "${var.component_name}-${var.env}.${var.domain_name}"
  type    = "A"
  ttl     = 30
  records = [aws_instance.instance.private_ip]
}

resource "null_resource" "ansible_run" {
  provisioner "remote-exec" {
    connection {
      type     = "ssh"
      user     = "ec2-user"
      password = "DevOps321"
      host     = aws_instance.instance.private_ip
    }

    inline = [
      "sudo labauto ansible",
      "ansible-pull -i localhost, -U https://github.com/dsaniset/roboshop-ansible -e app_name=${var.component_name} -e env=${var.env} -e vault_token=${var.vault_token} main.yml",
    ]
  }
}
