// Task Definition
resource "aws_ecs_task_definition" "test-app-task-definition" {
  family = "test-java-app-task-definition"
  //  execution_role_arn = aws_iam_role.ecsTaskExecutionRole.arn  //Optional
  //  task_role_arn = ""  //according the access of the task

  //   = aws_iam_role.ecsTaskExecutionRole.arn  //This role is required by tasks to pull container images and publish container logs to Amazon CloudWatch on your behalf. If you do not have the ecsTaskExecutionRole already, we can create one for you.
  container_definitions = <<EOF
[
  {
    "name": "fist-app-container",
    "image": "${aws_ecr_repository.test-java-app.repository_url}:${var.image-tag}",
    "cpu": 512,
    "memoryReservation": 1024,
    "essential": true,
    "readonlyRootFilesystem": false,
    "environment": [
      {"name": "key1", "value": "value1"}
    ],
    "command": [],
    "mountPoints": [],
    "volumesFrom": [],
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
}