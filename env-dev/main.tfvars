env = "dev"
domain_name = ".devops24.shop"
zone_id = "Z09304471M1HNSZIX3178"

db_instances = {
  mysql = {
    app_port = 3306
    instance_type = "t3.micro"
  }
  redis = {
    app_port = 6379
    instance_type = "t3.micro"
  }
  rabbitmq = {
    app_port = 5671
    instance_type = "t3.micro"
  }
  mongodb = {
    app_port = 27017
    instance_type = "t3.micro"
  }
}

app_instances = {
  catalogue = {
    app_port = 8080
    instance_type = "t3.micro"
  }
  user = {
    app_port = 8080
    instance_type = "t3.micro"
  }
  cart = {
    app_port = 8080
    instance_type = "t3.micro"
  }
  shipping = {
    app_port = 8080
    instance_type = "t3.micro"
  }
  payment = {
    app_port = 8080
    instance_type = "t3.micro"
  }
  dispatch = {
    app_port = 8080
    instance_type = "t3.micro"
  }
}

web_instances = {
  frontend = {
    app_port = 80
    instance_type = "t3.micro"
  }
}
