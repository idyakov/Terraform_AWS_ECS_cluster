variable "region" {
  type    = string
  default = "us-east-1"
}
#variable "awsAccessKey" {}
#variable "awsSecretKey" {}
variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "aws_ecs_cluster" {
  type        = string
  description = "Please type the name of your cluster"
}

variable "ServiceName" {
  type    = string
  default = "Yourapp"
}

variable "key_name" {
  type        = string
  description = "Please insert your ssh key name for the EC2"
}

#Allows choosing your own app from the ECR
variable "ImageName" {
  type    = string
  default = "940236515386.dkr.ecr.us-east-1.amazonaws.com/docker_file:latest"
}

variable "ContainerMemory" {
  type    = number
  default = 256
}
variable "PortNumber" {
  type    = number
  default = 80
}
variable "desired_count_services" {
  type    = number
  default = 2
}
variable "max" {
  description = "max_EC2_of_ASG"
  type        = number
  default     = 4
}
variable "min" {
  description = "min_EC2_of_ASG"
  type        = number
  default     = 2
}
variable "dsr" {
  description = "desired_EC2_of_ASG"
  type        = number
  default     = 2
}
