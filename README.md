# Provisioning VPC, ECS and ALB using Terraform
![](Diagram_Terraform_ECS.JPG)

This is an example that implies that you have already an AWS account and Terraform CLI installed in your Linux or Windows system/>
The users can deploy their own app/website via this infrastructure (variable.tf allows to change name of the Image. In this example used by AWS Elastic Container Repository.

It consit of:/>
1 Virtual Private Cloud 10.0.0.0/16/>
2. Application Load Balancer/>
3. Internet Gateway routed to our ALB/>
4. Distributed public subnets (10.0.0.0/24, 10.0.1.0/24)/>
5. 2 EC2 instances assigned to the ECS Cluster with ssh access/>
6. Tasks definitions (containers)/>
7. Autoscaling group that automate availability of our EC2 instances/>
8. The subnets distributing into two divided AZ/>

In this repository, each file is distributed to better defining what we want to build (or change)/>
The file variables allow changing the capacity of the desired configuration for the infrastracture/>

## How to create the infrastructure?/>
git clone github.com/idyakov/Terraform-AWS-ECS-cluster/>
cd Terraform-AWS-ECS-cluster/>
terraform init/>
terraform plan/>
terrafrom apply/>
/>
Note: it can take about 5 minutes to provision all resources/>

## How to delete the infrastructure?/>
terraform destroy/>

## For reference:/>
Cluster using container Instances (EC2 launch type)/>
SSH connection allows you to do troubleshooting or update within EC2 instances/>
In this repository, each file is distributed to better defining what we want to build (or change)/>
The file variables allow changing the capacity of the desired configuration for the infrastracture/>
