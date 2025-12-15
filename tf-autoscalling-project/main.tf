# VPC
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "three-services-vpc"
  }
}

# SUBNETS
resource "aws_subnet" "public_a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_a
  availability_zone       = "${var.region}a"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-a"
  }
}

resource "aws_subnet" "public_b" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_b
  availability_zone       = "${var.region}b"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-b"
  }
}

# SECURITY GROUPS
resource "aws_security_group" "alb_sg" {
  name        = "alb-sg"
  description = "Allow HTTP"
  vpc_id      = aws_vpc.main.id

  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "ec2_sg" {
  name        = "ec2-sg"
  description = "Allow ALB to reach EC2"
  vpc_id      = aws_vpc.main.id

  ingress {
    protocol        = "tcp"
    from_port       = 80
    to_port         = 80
    security_groups = [aws_security_group.alb_sg.id]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# APPLICATION LOAD BALANCER
resource "aws_lb" "app_lb" {
  name               = "three-service-alb"
  load_balancer_type = "application"
  internal           = false
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [
    aws_subnet.public_a.id,
    aws_subnet.public_b.id
  ]
}


# TARGET GROUPS
resource "aws_lb_target_group" "mobile_tg" {
  name     = "mobile-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
}

resource "aws_lb_target_group" "laptop_tg" {
  name     = "laptop-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
}

resource "aws_lb_target_group" "grocery_tg" {
  name     = "grocery-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
}

# LISTENER
resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Invalid Path"
      status_code  = "404"
    }
  }
}

# LISTENER RULES (PATH ROUTING)
resource "aws_lb_listener_rule" "mobile_rule" {
  listener_arn = aws_lb_listener.http_listener.arn
  priority     = 1

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.mobile_tg.arn
  }

  condition {
    path_pattern {
      values = ["/mobile*"]
    }
  }
}

resource "aws_lb_listener_rule" "laptop_rule" {
  listener_arn = aws_lb_listener.http_listener.arn
  priority     = 2

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.laptop_tg.arn
  }

  condition {
    path_pattern {
      values = ["/laptop*"]
    }
  }
}

resource "aws_lb_listener_rule" "grocery_rule" {
  listener_arn = aws_lb_listener.http_listener.arn
  priority     = 3

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.grocery_tg.arn
  }

  condition {
    path_pattern {
      values = ["/grocery*"]
    }
  }
}

# LAUNCH TEMPLATES (Mobile, Laptop, Grocery)
resource "aws_launch_template" "mobile_lt" {
  name = "mobile-lt"

  image_id               = var.ami
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

user_data = base64encode(<<EOF
#!/bin/bash
dnf update -y
dnf install -y httpd
mkdir -p /var/www/html/mobile
echo '<h1> Hello this is my mobile loadbalancer page...! </h1>' >> /var/www/html/mobile/index.html
hostname >> /var/www/html/mobile/index.html
systemctl start httpd
systemctl enable httpd
EOF
)
}

resource "aws_launch_template" "laptop_lt" {
  name = "laptop-lt"

  image_id               = var.ami
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

user_data = base64encode(<<EOF
#!/bin/bash
dnf update -y
dnf install -y httpd
mkdir -p /var/www/html/laptop
echo '<h1> Hello this is my laptop loadbalancer page...! </h1>' >> /var/www/html/laptop/index.html
hostname >> /var/www/html/laptop/index.html
systemctl start httpd
systemctl enable httpd
EOF
)
}

resource "aws_launch_template" "grocery_lt" {
  name = "grocery-lt"

  image_id               = var.ami
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

user_data = base64encode(<<EOF
#!/bin/bash
dnf update -y
dnf install -y httpd
mkdir -p /var/www/html/grocery
echo '<h1> Hello this is my grocery loadbalancer page...! </h1>' >> /var/www/html/grocery/index.html
hostname >> /var/www/html/grocery/index.html
systemctl start httpd
systemctl enable httpd
EOF
)
}

# AUTO SCALING GROUPS (3 Groups)
resource "aws_autoscaling_group" "mobile_asg" {
  name               = "mobile-asg"
  max_size           = var.max_size
  min_size           = var.min_size
  desired_capacity   = var.desired_capacity
  vpc_zone_identifier = [
    aws_subnet.public_a.id,
    aws_subnet.public_b.id
  ]

  launch_template {
    id      = aws_launch_template.mobile_lt.id
    version = "$Latest"
  }

  target_group_arns = [aws_lb_target_group.mobile_tg.arn]
}

resource "aws_autoscaling_group" "laptop_asg" {
  name               = "laptop-asg"
  max_size           = var.max_size
  min_size           = var.min_size
  desired_capacity   = var.desired_capacity
  vpc_zone_identifier = [
    aws_subnet.public_a.id,
    aws_subnet.public_b.id
  ]

  launch_template {
    id      = aws_launch_template.laptop_lt.id
    version = "$Latest"
  }

  target_group_arns = [aws_lb_target_group.laptop_tg.arn]
}

resource "aws_autoscaling_group" "grocery_asg" {
  name               = "grocery-asg"
  max_size           = var.max_size
  min_size           = var.min_size
  desired_capacity   = var.desired_capacity
  vpc_zone_identifier = [
    aws_subnet.public_a.id,
    aws_subnet.public_b.id
  ]

  launch_template {
    id      = aws_launch_template.grocery_lt.id
    version = "$Latest"
  }

  target_group_arns = [aws_lb_target_group.grocery_tg.arn]
}
# INTERNET GATEWAY
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "three-service-igw"
  }
}
# PUBLIC ROUTE TABLE
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public-rt"
  }
}
# ROUTE TABLE ASSOCIATION
resource "aws_route_table_association" "public_a_rt" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_b_rt" {
  subnet_id      = aws_subnet.public_b.id
  route_table_id = aws_route_table.public_rt.id
}
