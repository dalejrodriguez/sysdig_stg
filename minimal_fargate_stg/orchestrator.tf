module "fargate-orchestrator-agent" {
  source  = "sysdiglabs/fargate-orchestrator-agent/aws"
  version = "0.1.0"

  vpc_id           = var.vpc_id
  subnets          = [var.subnet_a_id, var.subnet_b_id]
  access_key       = var.access_key
  collector_host = var.collector_url
  collector_port = 6443

  name             = "${var.prefix}-sysdig-orchestrator"
  agent_image      = "quay.io/sysdig/orchestrator-agent:latest"

  # True if the VPC uses an InternetGateway, false otherwise
  assign_public_ip = true

  tags = {
    description    = "Sysdig Serverless Agent Orchestrator"
  }
}
