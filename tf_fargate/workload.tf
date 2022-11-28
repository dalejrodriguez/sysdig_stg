

provider "sysdig" {
  sysdig_secure_api_token = var.sysdig_secure_api_token #"xxxx"
}
data "sysdig_fargate_workload_agent" "instrumented" {
  container_definitions = jsonencode([
            {
                "name": "sleep",
                "image": "dockerbadboy/art",
                "cpu": 1,
                "memory": 10,
                "portMappings": [],
                "essential": true,
                "command": [
                    "sleep",
                    "360"
                ],
                "environment": [],
                "mountPoints": [],
                "volumesFrom": []
            }
        ],

)

  sysdig_access_key     = var.sysdig_access_key #"xxx"

  workload_agent_image  = "quay.io/sysdig/workload-agent:latest"

  orchestrator_host     = var.orchestrator_host #"collector.sysdigcloud.com"
  orchestrator_port     = var.orchestrator_port #6443
}

resource "aws_ecs_task_definition" "fargate_task" {
  memory = "1024"
  cpu = "512"
  family = "sleep360"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]

  container_definitions    = "${data.sysdig_fargate_workload_agent.instrumented.output_container_definitions}"
}
