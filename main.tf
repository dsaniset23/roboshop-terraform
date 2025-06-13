module "db_instances"{
  for_each = var.db_instances
  source = "./module/ec2"
  app_port = each.value["app_port"]
  component_name = each.key
  env = var.env
  instance_type = each.value["instance_type"]
  domain_name = var.domain_name
  zone_id = var.zone_id
  vault_token = var.vault_token
}

module "app_instances"{
  depends_on = [module.db_instances]
  for_each = var.app_instances
  source = "./module/ec2"
  app_port = each.value["app_port"]
  component_name = each.key
  env = var.env
  instance_type = each.value["instance_type"]
  domain_name = var.domain_name
  zone_id = var.zone_id
  vault_token = var.vault_token
}

module "web_instances"{
  depends_on = [module.app_instances]
  for_each = var.web_instances
  source = "./module/ec2"
  app_port = each.value["app_port"]
  component_name = each.key
  env = var.env
  instance_type = each.value["instance_type"]
  domain_name = var.domain_name
  zone_id = var.zone_id
  vault_token = var.vault_token
}