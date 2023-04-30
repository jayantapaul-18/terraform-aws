# Specify the provider and access details
provider "aws" {
  region = var.aws_region
  # shared_config_files      = var.shared_config_files
  # shared_credentials_files = var.shared_credentials_files
  # profile                  = var.aws_profile
}

# Create a VPC to launch
resource "aws_vpc" "default" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    NAME = "Main VPC"
  }
}

# Create an internet gateway to give our subnet access to the outside world
resource "aws_internet_gateway" "default" {
  vpc_id = aws_vpc.default.id
}

# Grant the VPC internet access on its main route table
resource "aws_route" "internet_access" {
  route_table_id         = aws_vpc.default.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.default.id
}

# Create a subnet to launch our instances into
resource "aws_subnet" "default" {
  vpc_id                  = aws_vpc.default.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  tags = {
    Name = "Public Subnet"
  }
}

# Our default security group to access the instances
resource "aws_security_group" "default" {
  name        = "Project - Terraform"
  description = "Project - Terraform"
  vpc_id      = aws_vpc.default.id

  # SSH access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP access from the VPC
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # EFS default port
  ingress {
    from_port   = 2049
    to_port     = 20349
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Replication Port
  ingress {
    from_port   = 8089
    to_port     = 8089
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Management Port
  ingress {
    from_port   = 4598
    to_port     = 4598
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # NodeJS Port
  ingress {
    from_port   = 3018
    to_port     = 3018
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
# Creating key pair
resource "aws_key_pair" "aws_developer_key" {
  key_name   = var.key_name
  public_key = var.public_key_path
}

# Creating Instance
resource "aws_instance" "test-instance" {
  instance_type = "t2.micro"
  # Lookup the correct AMI based on the region we specified
  ami = lookup(var.aws_amis, var.aws_region)
  # SSH key that we have generated above for connection
  key_name = aws_key_pair.aws_developer_key.id
  # Attaching Security Group
  vpc_security_group_ids = var.vpc_security_group_ids
  # Subnet ID in which the instance will spawn
  subnet_id = aws_subnet.default.id
  tags = {
    NAME        = "test-instance"
    CONTACTS    = "jayatapaul.jp18@gmail.com"
    ENVIRONMENT = "test"
    STAGE       = "dev"
  }

  # Root Block Storage
  root_block_device {
    volume_size = "8"
    volume_type = "standard"
  }

  # EBS Block Storage
  ebs_block_device {
    device_name           = "/dev/sdb"
    volume_size           = "8"
    volume_type           = "standard"
    delete_on_termination = true
  }

}


