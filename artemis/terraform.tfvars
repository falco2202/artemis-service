project_name = "artemis"
region       = "ap-southeast-1"

instance_class = "db.t3.micro"

allocated_storage = 30

artemis_service_name = "artemis"

service_config = {
  "artemis" = {
    name           = "artemis"
    container_name = "artemis-nginx"
    host_port      = 443
    container_port = 443
    cpu            = 1024
    memory         = 3072
    desired_count  = 1

    autoscaling = {
      max_capacity = 5
      min_capacity = 1
      cpu = {
        target_value = 70
      }
    }
  }
}
