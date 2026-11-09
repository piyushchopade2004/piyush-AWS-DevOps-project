# Project 1 : AWS Infrastructure Deployment using Terraform (tf-NAT-gateway-project)

## Project Overview

This project demonstrates how to provision AWS infrastructure using **Terraform (Infrastructure as Code)**.

Using Terraform, I created a custom AWS VPC with public and private subnets, deployed two EC2 instances, and configured Internet connectivity using an Internet Gateway and NAT Gateway.

The main objective of this project is to understand AWS networking, EC2 provisioning, and infrastructure automation using Terraform.

## AWS Services Used

- **Amazon VPC:** Created a custom Virtual Private Cloud.
- **Public Subnet:** Hosted a publicly accessible EC2 instance.
- **Private Subnet:** Hosted an EC2 instance without a public IP.
- **Internet Gateway (IGW):** Enabled internet connectivity for the public subnet.
- **NAT Gateway:** Enabled outbound internet access for the private subnet.
- **Amazon EC2:** Deployed two virtual machines.
- **Security Group:** Configured SSH access.
- **Elastic IP:** Assigned a static public IP to the NAT Gateway.
- **Terraform:** Automated AWS infrastructure provisioning.

## Architecture

The project uses the following architecture:

```text
                  Internet
                     |
              Internet Gateway
                     |
              Custom AWS VPC
                     |
              ----------------
              |              |
         Public Subnet   Private Subnet
              |              |
          EC2 Instance   EC2 Instance
         (Amazon Linux)   (Ubuntu)
              |              |
              |          NAT Gateway
              |              |
              ------ Internet
```

### File Description

| File | Description |
|---|---|
| `awsprofile.tf` | Configures AWS provider and region |
| `main.tf` | Defines AWS infrastructure resources |
| `vars.tf` | Declares Terraform variables |
| `terraform.tfvars` | Stores variable values |
| `README.md` | Project documentation |

## Infrastructure Details

1. Created a custom VPC with CIDR block.
2. Created public and private subnets.
3. Attached an Internet Gateway to the VPC.
4. Created an Elastic IP for the NAT Gateway.
5. Configured a NAT Gateway in the public subnet.
6. Created and configured a private route table.
7. Associated the private subnet with the private route table.
8. Configured internet routing for the public subnet.
9. Created a Security Group allowing SSH access.
10. Launched two EC2 instances:
    - Public EC2: Amazon Linux
    - Private EC2: Ubuntu

## Prerequisites

Before running this project, make sure you have:

- An AWS account.
- Terraform installed.
- AWS CLI installed.
- AWS IAM user with the required permissions.
- AWS CLI profile configured.
- Existing EC2 key pairs.
- An existing IAM instance profile.

## How to Execute the Project

### Step 1: Clone the Repository

```bash
git clone https://github.com/your-username/terraform-aws-infrastructure.git
```

### Step 2: Navigate to the Project Directory

```bash
cd terraform-aws-infrastructure
```

### Step 3: Configure AWS Credentials

Configure your AWS CLI profile:

```bash
aws configure --profile piyush_terraform_user
```

Make sure the profile name matches your AWS provider configuration.

### Step 4: Initialize Terraform

```bash
terraform init
```

### Step 5: Validate Configuration

```bash
terraform validate
```

### Step 6: Check Execution Plan

```bash
terraform plan
```

### Step 7: Deploy Infrastructure

```bash
terraform apply
```

Type `yes` when prompted.

### Step 8: Destroy Infrastructure

After completing the project, remove the resources to avoid unnecessary AWS charges.

```bash
terraform destroy
```

Type `yes` when prompted.

## Key Learnings

Through this project, I gained practical experience in:

- Infrastructure as Code using Terraform.
- AWS VPC and subnet configuration.
- Public and private network architecture.
- Internet Gateway and NAT Gateway configuration.
- EC2 instance provisioning.
- AWS Security Group configuration.
- Terraform variables and provider configuration.
- Terraform initialization, validation, planning, and deployment.

## Conclusion

This project helped me understand how to automate AWS infrastructure deployment using Terraform. It demonstrates practical knowledge of AWS networking, EC2 provisioning, and Infrastructure as Code concepts.

**Technologies:** Terraform | AWS | VPC | EC2 | NAT Gateway | Internet Gateway | Linux

# Project 2 : AWS Application Load Balancer with Path-Based Routing and Auto Scaling using Terraform. (tf-autoscalling-project)

## Project Overview

This project demonstrates how to deploy multiple web applications on AWS using Terraform (Infrastructure as Code).

I created an AWS Application Load Balancer (ALB) that routes incoming HTTP requests to three different web applications based on URL paths:

- `/mobile`
- `/laptop`
- `/grocery`

Each application has its own Target Group, Launch Template, and Auto Scaling Group.

The infrastructure is deployed inside a custom AWS VPC across two Availability Zones to provide scalability and high availability.

## AWS Services Used

- **Amazon VPC:** Created an isolated network environment.
- **Public Subnets:** Deployed resources across two Availability Zones.
- **Internet Gateway:** Enabled internet connectivity.
- **Application Load Balancer:** Distributed incoming HTTP traffic.
- **Target Groups:** Managed traffic for individual applications.
- **Launch Templates:** Defined EC2 instance configurations.
- **Auto Scaling Groups:** Automatically managed EC2 instances.
- **Amazon EC2:** Hosted the web applications.
- **Security Groups:** Controlled inbound and outbound traffic.
- **Terraform:** Automated infrastructure provisioning.

## Architecture Diagram

```text
                       Internet
                          |
                          |
                 Application Load Balancer
                          |
                    HTTP Listener
                       Port 80
                          |
                 Path-Based Routing
                          |
          +---------------+---------------+
          |               |               |
      /mobile          /laptop         /grocery
          |               |               |
      Mobile TG        Laptop TG       Grocery TG
          |               |               |
      Mobile ASG       Laptop ASG      Grocery ASG
          |               |               |
      EC2 Instances    EC2 Instances   EC2 Instances
          |               |               |
      Mobile App       Laptop App      Grocery App
          
                 Custom AWS VPC
                  /          \
             Public A      Public B
              us-east-1a   us-east-1b
```

### File Description

| File | Description |
|---|---|
| `main.tf` | Creates AWS infrastructure resources |
| `vars.tf` | Defines Terraform variables |
| `terraform.tfvars` | Provides variable values |
| `outputs.tf` | Displays ALB DNS name |
| `README.md` | Project documentation |

## Application Routing

The ALB uses path-based routing to forward incoming requests to different Target Groups.

| URL Path | Target Group | Application |
|---|---|---|
| `/mobile` | mobile-tg | Mobile Application |
| `/laptop` | laptop-tg | Laptop Application |
| `/grocery` | grocery-tg | Grocery Application |

Example:

```text
http://ALB-DNS/mobile
http://ALB-DNS/laptop
http://ALB-DNS/grocery
```

Each application displays a different welcome message along with the EC2 hostname.

Unknown paths return a 404 Invalid Path response.

## Auto Scaling Configuration

Each application has its own Auto Scaling Group.

| Configuration | Value |
|---|---|
| Minimum Capacity | 1 |
| Desired Capacity | 2 |
| Maximum Capacity | 3 |
| Instance Type | t3.micro |
| Operating System | Amazon Linux |
| Availability Zones | us-east-1a and us-east-1b |

Auto Scaling Groups maintain the desired number of EC2 instances and can scale within the configured minimum and maximum limits.

**Note:** Automatic scaling based on CPU utilization is not configured in this project. The Auto Scaling Groups use the configured capacity settings.

## Prerequisites

Before deploying this project, make sure you have:

- AWS Account
- Terraform installed
- AWS CLI installed
- AWS IAM user with required permissions
- AWS CLI credentials configured
- Basic knowledge of AWS and Terraform

## How to Deploy the Project

### Step 1: Clone the Repository

```bash
git clone https://github.com/your-username/terraform-alb-auto-scaling.git
```

### Step 2: Navigate to Project Directory

```bash
cd terraform-alb-auto-scaling
```

### Step 3: Configure AWS Credentials

```bash
aws configure
```

Enter your AWS Access Key, Secret Key, and region.

### Step 4: Initialize Terraform

```bash
terraform init
```

### Step 5: Validate Terraform Configuration

```bash
terraform validate
```

### Step 6: Review Execution Plan

```bash
terraform plan
```

### Step 7: Deploy AWS Infrastructure

```bash
terraform apply
```

Type `yes` to confirm.

### Step 8: Get ALB DNS Name

After successful deployment, run:

```bash
terraform output alb_dns
```

Copy the DNS name and open it in your browser with the following paths:

```text
http://ALB-DNS/mobile
http://ALB-DNS/laptop
http://ALB-DNS/grocery
```

### Step 9: Destroy Infrastructure

After testing, delete the infrastructure to avoid unnecessary AWS charges.

```bash
terraform destroy
```

Type `yes` to confirm.

## Key Learnings

Through this project, I gained practical experience in:

- Creating AWS infrastructure using Terraform.
- Configuring VPC and public subnets.
- Deploying an Application Load Balancer.
- Implementing path-based routing.
- Creating multiple Target Groups.
- Configuring EC2 Launch Templates.
- Implementing Auto Scaling Groups.
- Deploying multiple web applications.
- Understanding high availability across Availability Zones.
- Managing infrastructure using Terraform commands.

## Conclusion

This project demonstrates how to deploy and manage multiple web applications using AWS Application Load Balancer, EC2, Auto Scaling Groups, and Terraform.

It helped me understand load balancing, path-based routing, infrastructure automation, and scalable AWS architecture.

**Technologies:** AWS | Terraform | VPC | EC2 | ALB | Target Groups | Launch Templates | Auto Scaling | Linux
