variable "instance_type" {
    default     = "t2.micro"
    description = "ec2-instance type"
}

variable "iam_instance_profile" {
    default     = "EC2_SSM"
    description = "ec2-iam role"
}


variable "subnet_id" {
}

variable "security_group" {
}

variable "user_data" {
}