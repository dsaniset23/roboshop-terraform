env = "dev"
domain_name = "devops24.shop"
zone_id = "Z09304471M1HNSZIX3178"

db_instances = {
  mysql = {
    app_port = 3306
    instance_type = "t3.small"
    volume_size = 30
  }
  redis = {
    app_port = 6379
    instance_type = "t3.small"
    volume_size = 30
  }
  rabbitmq = {
    app_port = 5672
    instance_type = "t3.small"
    volume_size = 30
  }
  mongodb = {
    app_port = 27017
    instance_type = "t3.small"
    volume_size = 30
  }
}

app_instances = {
  catalogue = {
    app_port = 8080
    instance_type = "t3.small"
    volume_size = 30
  }
  user = {
    app_port = 8080
    instance_type = "t3.small"
    volume_size = 30
  }
  cart = {
    app_port = 8080
    instance_type = "t3.small"
    volume_size = 30
  }
  shipping = {
    app_port = 8080
    instance_type = "t3.small"
    volume_size = 30
  }
  payment = {
    app_port = 8080
    instance_type = "t3.small"
    volume_size = 30
  }
  dispatch = {
    app_port = 8080
    instance_type = "t3.small"
    volume_size = 30
  }
}

web_instances = {
  frontend = {
    app_port = 80
    instance_type = "t3.small"
    volume_size = 30
  }
}
