env = "dev"
domain_name = "devops24.shop"
zone_id = "Z09304471M1HNSZIX3178"

db_instances = {
  mysql = {
    app_port = 3306
    instance_type = "t3.micro"
    volume_size = 20
  }
  redis = {
    app_port = 6379
    instance_type = "t3.micro"
    volume_size = 20
  }
  rabbitmq = {
    app_port = 5672
    instance_type = "t3.micro"
    volume_size = 20
  }
  mongodb = {
    app_port = 27017
    instance_type = "t3.micro"
    volume_size = 20
  }
}

app_instances = {
  catalogue = {
    app_port = 8080
    instance_type = "t3.micro"
    volume_size = 20
  }
  user = {
    app_port = 8080
    instance_type = "t3.micro"
    volume_size = 20
  }
  cart = {
    app_port = 8080
    instance_type = "t3.micro"
    volume_size = 20
  }
  shipping = {
    app_port = 8080
    instance_type = "t3.micro"
    volume_size = 20
  }
  payment = {
    app_port = 8080
    instance_type = "t3.micro"
    volume_size = 20
  }
  dispatch = {
    app_port = 8080
    instance_type = "t3.micro"
    volume_size = 20
  }
}

web_instances = {
  frontend = {
    app_port = 80
    instance_type = "t3.micro"
    volume_size = 20
  }
}
