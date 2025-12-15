vpc_cidr        = "10.0.0.0/16"
public_subnet_a = "10.0.1.0/24"
public_subnet_b = "10.0.2.0/24"

ami             = "ami-0bdd88bd06d16ba03"
instance_type   = "t3.micro"

min_size        = 1
max_size        = 3
desired_capacity = 2