module "instances"{
  for_each = var.instance
  source = "./module"
  component_name = each.key
}

variable "instance" {
  default = {
    frontend = {}
    mongodb = {}
    catalogue = {}
    redis = {}
    user = {}
    cart = {}
    shipping = {}
    mysql = {}
    redditmq = {}
    payment = {}
    dispatch = {}
  }
}