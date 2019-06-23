// Autoscaling group
data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_autoscaling_group" "test-app-autoscaling-group" {
  name = "test-app-autoscaling-group"
  max_size = 1
  min_size = 0
  desired_capacity = 1
  launch_configuration = aws_launch_configuration.test-app-launch_configuration.name
  availability_zones = [data.aws_availability_zones.available.names[0]]
  vpc_zone_identifier = ["subnet-bb46cbe7"]
  //  force_delete = true  // Error: error deleting Autoscaling Launch Configuration (test-app-launch-configuration): ResourceInUse: Cannot delete launch configuration test-app-launch-configuration because it is attached to AutoScalingGroup test-app-autoscaling-group
  //status code: 400, request id: 491cfe68-9580-11e9-9ae7-8ff6b4f514f1
  //有 force_delete 也是一样的错

}