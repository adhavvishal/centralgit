variable "vpc_cidr_block" {
  description = "CIDR block for VPC"
  type        = string
  default     = "192.168.0.0/16"
}

variable "public_subnet_count" {
  description = "Number of public subnets."
  type        = number
  default     = 2
}

variable "private_subnet_count" {
  description = "Number of private subnets."
  type        = number
  default     = 1
}



variable "public_subnet_cidr_blocks" {
  description = "Available cidr blocks for private subnets."
  type        = list(string)
  default     = [
    "192.168.0.0/24",
    "192.168.1.0/24"
  ]
}

variable "private_subnet_cidr_blocks" {
  description = "Available cidr blocks for private subnets."
  type        = list(string)
  default     = [
    "192.168.2.0/24",
  ]
}

variable "aws_ami" {
  description = "Available AMI for ec2-instances"
  type        = string
  default     = "ami-0af25d0df86db00c1"
}
 



