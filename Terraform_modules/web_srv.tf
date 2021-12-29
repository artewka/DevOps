data "terraform_remote_state" "vpc" {
  backend = "local"

  config = {
    path = "/home/artem.yakymchuk/Desktop/education/terraform/Terraform_modules/vpc/terraform.tfstate"
  }
}

module "vpc" {
  source = "./vpc"
}

 module "ec2" {
   source = "./ec2"

 vpc_cidr_id            = module.vpc.vpc_cidr_id 
 public_count           = 2
 private_count          = 1
 public_subnet_id       = element(module.vpc.public_subnet_ids[*],0)
 private_subnet_id      = element(module.vpc.private_subnet_ids[*],0)
 public_security_group  = [module.vpc.sg_public]
 private_security_group = [module.vpc.sg_private]
 }

 