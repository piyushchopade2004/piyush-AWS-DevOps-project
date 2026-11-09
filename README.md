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
