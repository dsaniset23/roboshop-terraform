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
  root_block_device {
    volume_size = var.volume_size
  }

  lifecycle {
    ignore_changes = [
      ami,
    ]
  }
  # --- Lifecycle configuration ---
  # ignore_changes tells Terraform to ignore specific attribute changes
  # during future 'terraform apply' runs.
  # Here, we ignore AMI changes to prevent unnecessary EC2 replacement
  # when the AMI ID updates (e.g., base image refresh by AWS).
  # This is useful when you don't want your instance to be destroyed
  # and recreated automatically due to AMI version drift.
}

resource "aws_route53_record" "record" {
  zone_id = var.zone_id //Gave ami_id instead of zoneId
  name    = "${var.component_name}-${var.env}.${var.domain_name}"
  type    = "A"
  ttl     = 30
  records = [aws_instance.instance.private_ip]
}

resource "null_resource" "ansible_run" {

  # --- Triggers configuration ---
  # 'triggers' defines conditions that force this null_resource to rerun.
  # Terraform will recreate (and re-run provisioners) whenever any trigger value changes.
  # Here, we link it to the EC2 instance ID, ensuring provisioning runs again
  # whenever a new instance is created (i.e., instance replacement).
  # This is critical because null_resource does NOT automatically detect
  # when the underlying EC2 instance has been recreated.
  triggers = {
    instance_id = aws_instance.instance.id
  }
  provisioner "remote-exec" {
    connection {
      type     = "ssh"
      user     = data.vault_generic_secret.ssh.data["user"]
      password = data.vault_generic_secret.ssh.data["password"]
      host     = aws_instance.instance.private_ip
    }

    inline = [
      "sudo labauto ansible",
      "ansible-pull -i localhost, -U https://github.com/dsaniset23/roboshop-ansible -e app_name=${var.component_name} -e env=${var.env} -e vault_token=${var.vault_token} main.yml",
    ]
  }
}
