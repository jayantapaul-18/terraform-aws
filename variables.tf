variable "key_name" {
  type        = string
  default     = "aws-deployer-key"
  description = "Desired name of AWS key pair"
}
# Defining Public Key
variable "public_key_path" {
  type    = string
  default = "./aws-developer-key.pub"
}

# Defining Private Key
variable "private_key_path" {
  type    = string
  default = "./aws-developer-key"
}
variable "shared_config_files" {
  type    = list(string)
  default = ["/Users/jp18/.aws/config"]
}

variable "shared_credentials_files" {
  type    = list(string)
  default = ["/Users/jp18/.aws/credentials"]
}

variable "aws_profile" {
  type    = string
  default = "profile jpaul"

}
variable "aws_region" {
  type        = string
  description = "AWS region to launch servers."
  default     = "us-east-1"
}

# Amazon Linux 2023 AMI 2023.0.20230419.0 x86_64 HVM kernel-6.1
// ami-02396cdd13e9a1257
variable "aws_amis" {
  type = map(any)
  default = {
    us-east-1 = "ami-02396cdd13e9a1257"
  }
}

variable "vpc_security_group_ids" {
  description = "A list of security group IDs to associate with"
  type        = list(string)
  default     = null
}
