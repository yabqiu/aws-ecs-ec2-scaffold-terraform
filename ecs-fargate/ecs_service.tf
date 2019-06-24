// Task Definition
resource "aws_ecs_task_definition" "test-app-task-definition" {
  family = "test-java-app-task-definition"
  network_mode = "awsvpc"  //Fargate only supports network mode ‘awsvpc’.
  requires_compatibilities = [
    "FARGATE"
  ]
  cpu = 512
  memory = 1024  // Fargate requires that 'cpu' be defined at the task level, move cpu/memory from container_definitions to task level
    execution_role_arn = aws_iam_role.ecsTaskExecutionRole.arn  // Fargate requires task definition to have execution role ARN to support log driver awslogs.
  //  task_role_arn = ""  //according the access of the task

  //   = aws_iam_role.ecsTaskExecutionRole.arn  //This role is required by tasks to pull container images and publish
  //container logs to Amazon CloudWatch on your behalf. If you do not have the ecsTaskExecutionRole already, we can create one for you.
  //portMappings:  When networkMode=awsvpc, the host ports and container ports in port mappings must match
  container_definitions = <<EOF
[
  {
    "name": "fist-app-container",
    "image": "${aws_ecr_repository.test-java-app.repository_url}:${var.image-tag}",
    "essential": true,
    "environment": [
      {"name": "key1", "value": "value1"}
    ],
    "command": [],
    "portMappings": [
      {
        "containerPort": 8080,
        "hostPort": 8080
      }
    ],
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "${aws_cloudwatch_log_group.test-java-app.name}",
        "awslogs-region": "us-east-1",
        "awslogs-stream-prefix": "first-app"
      }
    }
  }
]
EOF
}

resource "aws_cloudwatch_log_group" "test-java-app" {
  name = "/ecs/test-java-app"
  retention_in_days = 1
}

// ECS Service
resource "aws_ecs_service" "test-app-service" {
  name = "test-app-service"
  task_definition = aws_ecs_task_definition.test-app-task-definition.arn
  cluster = aws_ecs_cluster.test-app-cluster.name
  desired_count = 1
  launch_type = "FARGATE"
  network_configuration { // Network Configuration must be provided when networkMode 'awsvpc' is specified
    security_groups = ["sg-0c5cf22aef46d7d98"]  // no SSH required, other security groups, we here
    assign_public_ip = true //CannotPullContainerError: Error response from daemon:
    //Get https://069762108088.dkr.ecr.us-east-1.amazonaws.com/v2/: net/http: request
    //canceled while waiting for connection (Client.Timeout exceeded while awaiting headers
    subnets = data.aws_subnet_ids.all_subnet_ids.ids
  }

}

data "aws_subnet_ids" "all_subnet_ids" {
  vpc_id = "vpc-11fd216b"
}

