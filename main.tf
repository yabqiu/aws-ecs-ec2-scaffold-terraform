// ECR
resource "aws_ecr_repository" "test-java-app" {
  name = "test-java-app"
}

output "ecr_repository_url" {
  value = "${aws_ecr_repository.test-java-app.repository_url}"
}

// ECS Cluster
resource "aws_ecs_cluster" "test-app-cluster" {
  name = "test-app-cluster"
}

// Variables
variable "image-tag" {
  default = "1.02"
}