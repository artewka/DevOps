
module "vpc" {
  source = "./vpc"
}

 module "web" {
   source = "./ec2"

    count                        = 2
    subnet_id                    = element(module.vpc.private_subnet_ids[*],count.index)
    security_group               = [module.vpc.sg_public]
    user_data                    = file("~/Desktop/Terraform_modules/ec2/web_srv.sh")
 }

  module "db" {
   source = "./ec2"

    count                        = 1
    subnet_id                    = element(module.vpc.private_subnet_ids[*],count.index)
    security_group               = [module.vpc.sg_private]
    user_data                    = file("~/Desktop/Terraform_modules/ec2/db_srv.sh")
    
 }

   module "bastion" {
   source = "./ec2"

    count                        = 1
    subnet_id                    = element(module.vpc.public_subnet_ids[*],count.index)
    security_group               = [module.vpc.bastion]
    user_data                    = false

    
 }