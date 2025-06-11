module "instances"{
  for_each = var.instances
  source = "./module/ec2"
  app_port = each.value["app_port"]
  component_name = each.key
  env = var.env
  instance_type = each.value["instance_type"]
}
