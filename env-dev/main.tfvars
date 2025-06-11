env = "dev"
instances = {
  frontend = {
    app_port = 80
    instance_type = "t3.micro"
  }

  catalogue = {
    app_port = 8080
    instance_type = "t3.micro"
  }
}