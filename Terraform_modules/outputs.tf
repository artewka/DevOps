output "vpc_public_subnet" {
  value = module.vpc.public_subnet_ids[*]
}

output "vpc_private_subnet" {
  value = module.vpc.private_subnet_ids[*]
}

output "sg_public_srv" {
  value = module.vpc.sg_public
}

output "sg_private_srv" {
  value = module.vpc.sg_private
}

output "vpc_cidr_id" {
  value = module.vpc.vpc_cidr_id
}

output "aws_public_instance_id" {
  value = module.ec2.aws_public_instance_id
}

output "aws_private_instance_id" {
  value = module.ec2.aws_private_instance_id
}