terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.81.0"
    }
  }
}

resource "aws_instance" "instance" {
  ami           = data.aws_ami.devops_instance.id
  instance_type = "t3.micro"
  vpc_security_group_ids = [data.aws_security_group.allow_all.id] //Mentioned security_groups instead of vpc_security_group_ids, security-groups has been deprecated in aws
  tags = {
    Name = var.component_name
  }
}

resource "aws_route53_record" "record" {
  zone_id = "Z09304471M1HNSZIX3178" //Gave ami_id instead of zoneId
  name    = "${var.component_name}.devops24.shop"
  type    = "A"
  ttl     = 30
  records = [aws_instance.instance.private_ip]
}

variable "component_name"{}

data "aws_ami" "devops_instance" {  //Initially gave aws_instance
  most_recent      = true
  name_regex       = "RHEL-9-DevOps-Practice"   //Gave instance name instead of id
  owners           = ["973714476881"]
}

data "aws_security_group" "allow_all" {
  name = "allow-all"
}