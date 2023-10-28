terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.8.0"
    }
  }

  backend "s3" {
    bucket  = "cta-artemis-service"
    key     = "state/artemis.tfstate"
    region  = "ap-southeast-1"
    encrypt = "true"
  }
}

provider "aws" {
  region = var.region
}

module "database" {
  source              = "../modules/database"
  project_name        = var.project_name
  database_subnets_id = var.database_subnets_id
  database_sg_id      = var.database_sg_id
  vpc_id              = var.vpc_id
  username            = var.database_username
  password            = var.database_password
  instance_class      = var.instance_class
  allocated_storage   = var.allocated_storage
}

module "acm" {
  source       = "../modules/acm"
  host_zone_id = var.host_zone_id
  domain_name  = var.host_domain_artemis
}

module "alb" {
  source            = "../modules/alb"
  vpc_id            = var.vpc_id
  security_group_id = [var.public_sg_id]
  public_subnets_id = [var.public_subnets_id]
  service_name      = var.artemis_service_name
  certificate_arn   = module.acm.certificate_arn
  lb_port           = 443
  lb_protocol       = "HTTPS"
  lb_path           = "/"
}

module "route53" {
  source       = "../modules/route53"
  app_lb       = module.alb.app_lb
  host_zone_id = var.host_zone_id
  host_domain  = var.host_domain_artemis
}

module "ecs" {
  source                    = "../modules/ecs_artemis"
  ecs_cluster_id            = var.ecs_cluster_id
  project_name              = var.project_name
  public_subnets_id         = var.public_subnets_id
  artemis_url               = "https://${var.host_domain_artemis}"
  security_group_id         = [var.public_sg_id]
  target_group_arn          = module.alb.target_group_arn
  task_defintion            = "artemis.json"
  volume_file               = "artemis-volume.json"
  database_endpoint         = module.database.database_endpoint
  database_username         = var.database_username
  database_password         = var.database_password
  gitlab_token              = var.gitlab_token
  jenkins_secret_push_token = var.jenkins_secret_push_token
  jenkins_url               = var.jenkins_url
  execution_role_arn        = var.ecs_task_execution_role_arn
  service                   = var.service_config.artemis
  gitlab_url                = var.gitlab_url
  efs_id                    = var.efs_id
  access_point_id           = var.access_point_id
  depends_on                = [module.database]
}
