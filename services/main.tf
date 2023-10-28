terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.8.0"
    }
  }

  backend "s3" {
    bucket  = "cta-artemis-service"
    key     = "state/artemis-service.tfstate"
    region  = "ap-southeast-1"
    encrypt = "true"
  }
}

provider "aws" {
  region = var.region
}

### Create ECS Cluster 
resource "aws_ecs_cluster" "ecs_cluster" {
  name = lower("${var.project_name}-cluster")
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

module "vpc" {
  source                      = "../modules/vpc"
  project_name                = var.project_name
  availability_zones          = var.availability_zones
  vpc_cidr_block              = var.vpc_cidr_block
  public_subnets_cidr_block   = var.public_subnets_cidr_block
  database_subnets_cidr_block = var.database_subnets_cidr_block
}

module "iam" {
  source       = "../modules/iam"
  project_name = var.project_name
}

module "efs" {
  source            = "../modules/efs"
  efs_sg_id         = module.vpc.efs_sg_id
  public_subnets_id = module.vpc.public_subnets_id
}

#### Gitlab service setup
module "acm_gitlab" {
  source       = "../modules/acm"
  host_zone_id = var.host_zone_id
  domain_name  = var.gitlab_domain
}

module "alb_gitlab" {
  source            = "../modules/alb"
  vpc_id            = module.vpc.vpc_id
  security_group_id = module.vpc.public_sg_id
  public_subnets_id = [module.vpc.public_subnets_id]
  service_name      = var.gitlab_service_name
  certificate_arn   = module.acm_gitlab.certificate_arn
  lb_port           = 80
  lb_protocol       = "HTTP"
  lb_path           = "/users/sign_in"
}

module "route53_gitlab" {
  source       = "../modules/route53"
  app_lb       = module.alb_gitlab.app_lb
  host_zone_id = var.host_zone_id
  host_domain  = var.gitlab_domain
}

module "ecs_gitlab" {
  source             = "../modules/ecs"
  ecs_cluster_id     = aws_ecs_cluster.ecs_cluster.id
  public_subnets_id  = module.vpc.public_subnets_id
  security_group_id  = module.vpc.public_sg_id
  target_group_arn   = module.alb_gitlab.target_group_arn
  execution_role_arn = module.iam.ecs_task_execution_role_arn
  task_defintion     = "gitlab.json"
  service            = var.service_config.gitlab
  volume_file        = var.volume_file_gitlab
  project_name       = var.project_name
  password           = var.password
}


### Jenkins service set up
module "acm_jenkins" {
  source       = "../modules/acm"
  host_zone_id = var.host_zone_id
  domain_name  = var.jenkins_domain
}

module "alb_jenkins" {
  source            = "../modules/alb"
  vpc_id            = module.vpc.vpc_id
  security_group_id = module.vpc.public_sg_id
  public_subnets_id = [module.vpc.public_subnets_id]
  service_name      = var.jenkins_service_name
  certificate_arn   = module.acm_jenkins.certificate_arn
  lb_port           = 8080
  lb_protocol       = "HTTP"
  lb_path           = "/login"
}

module "route53_jenkins" {
  source       = "../modules/route53"
  app_lb       = module.alb_jenkins.app_lb
  host_zone_id = var.host_zone_id
  host_domain  = var.jenkins_domain
}

module "ecs_jenkins" {
  source             = "../modules/ecs"
  ecs_cluster_id     = aws_ecs_cluster.ecs_cluster.id
  public_subnets_id  = module.vpc.public_subnets_id
  security_group_id  = module.vpc.public_sg_id
  target_group_arn   = module.alb_jenkins.target_group_arn
  execution_role_arn = module.iam.ecs_task_execution_role_arn
  task_defintion     = "jenkins.json"
  service            = var.service_config.jenkins
  volume_file        = var.volume_file_jenkins
  project_name       = var.project_name
  password           = var.password
}

module "ec2_agent" {
  source        = "../modules/ec2"
  instance_type = var.instance_type
  agent_sg_id   = module.vpc.agent_sg_id
  subnet_id     = module.vpc.public_subnets_id[0]
  public_key    = var.public_key
}
