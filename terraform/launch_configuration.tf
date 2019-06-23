// Launch Configuration
data "aws_ami" "amazon-linux2-ecs-ami" {   //must be an ECS ami, need docker
  most_recent = true
  owners = ["amazon"]
  filter {
    name = "name"
    values = ["amzn-ami-*-amazon-ecs-optimized"]
  }
}

output "amazon-linux2-ami" {
  value = data.aws_ami.amazon-linux2-ecs-ami.id
}

output "amazon-linux2-ami-name" {
  value = data.aws_ami.amazon-linux2-ecs-ami.name
}

data "aws_iam_instance_profile" "ecs-instance-role" {
  name = "ecsInstanceRole"
}

resource "aws_launch_configuration" "test-app-launch_configuration" {
  name = "test-app-launch-configuration"
  image_id = data.aws_ami.amazon-linux2-ecs-ami.id
  instance_type = "t2.medium"
  iam_instance_profile = data.aws_iam_instance_profile.ecs-instance-role.name  // Used to join ECS cluster
  security_groups = ["sg-0b996637d85c6b3df"]   // Allow SSH access, inspect ECS agent
  enable_monitoring = false

  //  associate_public_ip_address = false
  user_data = <<EOF
#!/bin/bash
echo ECS_CLUSTER=${aws_ecs_cluster.test-app-cluster.name} >> /etc/ecs/ecs.config
EOF
}