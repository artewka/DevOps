variable "instance_type" {
    default     = "t2.micro"
    description = "ec2-instance type"
}

variable "instance_iam" {
    default     = "EC2_SSM"
    description = "ec2-iam role"
}

variable "public_count" {
    default = "2"
    type = string
}

variable "private_count" {
    default = "1"
    type = string
}

variable "public_subnet_id" {
}


variable "private_subnet_id" {
}

variable "vpc_cidr_id" {
}

variable "public_security_group" {
}

variable "private_security_group" {
}