provider "aws" {
  region = var.region # you can change the Region and start deploy

  #  access_key = var.awsAccessKey
  #  secret_key = var.awsSecretKey
}
data "aws_availability_zones" "available" {}
data "aws_ami" "latest_amazon_linux" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-ecs-hvm-*-x86_64-ebs"]
  }
}

# Newtork deployment
resource "aws_vpc" "main" {
  #  name       = "cluster_vpc"
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "cluster_main"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "cluster_main"
  }
}

resource "aws_route_table" "main_cluster" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}

resource "aws_route_table_association" "public_az1" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.main_cluster.id
}

resource "aws_route_table_association" "public_az2" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.main_cluster.id
}

resource "aws_subnet" "public_subnet_1" {
  availability_zone       = data.aws_availability_zones.available.names[0]
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.0.0/24"
  map_public_ip_on_launch = true
  tags = {
    Name = "cluster_main_az1"
  }
}

resource "aws_subnet" "public_subnet_2" {
  availability_zone       = data.aws_availability_zones.available.names[1]
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  tags = {
    Name = "cluster_main_az2"
  }
}

resource "aws_security_group" "main_security_gr_ecs" {
  name   = "allow traffic"
  vpc_id = aws_vpc.main.id
  ingress {
    description = "TLS from VPC"
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#Application Load Balancer deploy
resource "aws_alb" "ecs_main" {
  name               = "ecs-alb-main"
  load_balancer_type = "application"
  subnets            = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]
  security_groups    = [aws_security_group.main_security_gr_ecs.id]
  internal           = false
  tags = {
    Name    = "ecs_main"
    Project = "ecs_main"
  }
}

resource "aws_alb_target_group" "ecs_main" {
  name        = "target-group-ecs-main"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id
  target_type = "instance"
}

resource "aws_alb_listener" "ecs_main" {
  load_balancer_arn = aws_alb.ecs_main.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    target_group_arn = aws_alb_target_group.ecs_main.arn
    type             = "forward"
  }
}

resource "aws_ecs_cluster" "main_cluster" {
  name = var.aws_ecs_cluster
}

resource "aws_launch_configuration" "ecs_main" {
  image_id        = data.aws_ami.latest_amazon_linux.id
  instance_type   = var.instance_type
  security_groups = [aws_security_group.main_security_gr_ecs.id]
  key_name        = var.key_name
  user_data       = templatefile("set_name_cl.sh", { cluster_name = aws_ecs_cluster.main_cluster.name })
  # Here we are attaching the IAM instance profile, which we created in the step 4.
  iam_instance_profile = aws_iam_instance_profile.ec2_ecs_role.name #Assigning the IAM role, to an EC2 instance on the fly
}

resource "aws_autoscaling_group" "ecs_main" {
  name                 = "ecs_autoscaling_group" #>>> dependens name of the Lunch configuration
  launch_configuration = aws_launch_configuration.ecs_main.name
  min_size             = var.min
  max_size             = var.max
  desired_capacity     = var.dsr
  vpc_zone_identifier  = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]
}

#Service - task definition combination
resource "aws_ecs_service" "main_cluster_services" {
  name = "ecs-services"
  #  launch_type     = "EC2"
  cluster         = aws_ecs_cluster.main_cluster.id
  task_definition = aws_ecs_task_definition.service.arn
  desired_count   = 2

  load_balancer {
    target_group_arn = aws_alb_target_group.ecs_main.arn
    container_name   = var.ServiceName
    container_port   = var.PortNumber
  }
}

resource "aws_ecs_task_definition" "service" {
  family = "service"
  container_definitions = templatefile("service.json", { name = var.ServiceName, image = var.ImageName,
  memory = var.ContainerMemory, containerPort = var.PortNumber })

  volume {
    name      = "service-storage"
    host_path = "/ecs/service-storage"
  }
}

output "load_balancer_ip" {
  description = "DNS_name_of_your_app"
  value       = aws_alb.ecs_main.dns_name
}
