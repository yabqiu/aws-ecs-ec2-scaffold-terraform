# aws-ecs-scaffold-terraform
A very basic AWS ECS setup terraform script sample

#### ECS with EC2

#### ECS with Fargate

###### Scaling
```bash
aws ecs update-service --cluster test-app-cluster \
 --service test-app-service --desired-count 10
```


https://github.com/arminc/terraform-ecs
https://github.com/terraform-aws-modules/terraform-aws-ecs
http://blog.shippable.com/setup-a-container-cluster-on-aws-with-terraform-part-2-provision-a-cluster