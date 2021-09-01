# Provisioning VPC, ECS and ALB using Terraform
![](Diagram_Terraform_ECS.JPG)
<br />
This is an example that implies that you have already an AWS account and Terraform CLI installed in your Linux or Windows system/>
The users can deploy their own app/website via this infrastructure (variable.tf allows to change name of the Image. In this example used by AWS Elastic Container Repository.<br />
<br />
It consit of:<br />
1 Virtual Private Cloud 10.0.0.0/16<br />
2. Application Load Balancer<br />
3. Internet Gateway routed to our ALB<br />
4. Distributed public subnets (10.0.0.0/24, 10.0.1.0/24)<br />
5. 2 EC2 instances assigned to the ECS Cluster with ssh access<br />
6. Tasks definitions (containers)<br />
7. Autoscaling group that automate availability of our EC2 instances<br />
8. The subnets distributing into two divided AZ<br />
<br />
In this repository, each file is distributed to better defining what we want to build (or change)<br />
The file variables allow changing the capacity of the desired configuration for the infrastracture<br />

## How to create the infrastructure?<br />
git clone github.com/idyakov/Terraform-AWS-ECS-cluster<br />
cd Terraform-AWS-ECS-cluster<br />
terraform init<br />
terraform plan<br />
terrafrom apply<br />
/>
Note: it can take about 5 minutes to provision all resources<br />

## How to delete the infrastructure?<br />
terraform destroy<br />

## For reference:<br />
Cluster using container Instances (EC2 launch type)<br />
SSH connection allows you to do troubleshooting or update within EC2 instances<br />
In this repository, each file is distributed to better defining what we want to build (or change)<br />
The file variables allow changing the capacity of the desired configuration for the infrastracture<br />