region       = "ap-southeast-1"
project_name = "artemis"

vpc_cidr_block              = "10.0.0.0/16"
availability_zones          = ["ap-southeast-1a", "ap-southeast-1b"]
public_subnets_cidr_block   = ["10.0.1.0/24", "10.0.2.0/24"]
database_subnets_cidr_block = ["10.0.3.0/24", "10.0.4.0/24"]

gitlab_service_name  = "gitlab-artemis"
jenkins_service_name = "jenkins-artemis"

volume_file_gitlab  = "gitlab-volume.json"
volume_file_jenkins = "jenkins-volume.json"

service_config = {
  "gitlab" = {
    name           = "gitlab"
    container_name = "gitlab-container"
    host_port      = 80
    container_port = 80
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
  },
  "jenkins" = {
    name           = "jenkins"
    container_name = "jenkins-container"
    host_port      = 8080
    container_port = 8080
    cpu            = 1024
    memory         = 2048
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

instance_type = "t3.small"
