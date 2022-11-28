#orchestrator.tf
provider "aws" {
region = var.s3_bucket_region
profile = var.s3_iam_profile
}

terraform {
    required_version = ">=1.0"
    backend "s3" {
        bucket = var.s3_bucket_name
        key = "terraform.tfstate"
        region = var.s3_bucket_region
        profile = var.s3_iam_profile
    }
    required_providers {

    sysdig = { 
      source = "sysdiglabs/sysdig"
      version = ">= 0.5.39" 
    } 

      aws = {
        source = "hashicorp/aws"
        version = "~> 3.69.0"
      }
      template = {
        version = "~> 2.2.0"
      }
    }


}
    module "fargate-orchestrator-agent" {
    source  = "sysdiglabs/fargate-orchestrator-agent/aws"
    version = "0.1.1"

    vpc_id           = var.vpc_id # "xxx"
    subnets          = var.subnets # [xxx]
    access_key       = var.sysdig_access_key #"xxx"

    name             = "sysdig-orchestrator"
    agent_image      = "quay.io/sysdig/orchestrator-agent:latest"

  # True if the VPC uses an InternetGateway, false otherwise
    assign_public_ip = true

    tags = {
        description    = "Sysdig Serverless Agent Orchestrator"
  }
}
