data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
    owners = ["099720109477"]
}

resource "aws_network_interface" "srv_public" {
  count           = var.public_count
  subnet_id       = var.public_subnet_id
  security_groups = var.public_security_group
}

resource "aws_network_interface" "srv_private" {
  count           = var.private_count
  subnet_id       = var.private_subnet_id
  security_groups = var.private_security_group

}


resource "aws_instance" "public_srv" {
    count                  = var.public_count
    ami                    = data.aws_ami.ubuntu.id
    instance_type          = var.instance_type
    iam_instance_profile   = var.instance_iam
    user_data              = file("~/Desktop/education/terraform/Terraform_modules/ec2/web_srv.sh")

    network_interface {
      network_interface_id = element(aws_network_interface.srv_public[*].id,count.index)
      device_index = 0
    }

    root_block_device {
      volume_size = 8
    }
    
}

resource "aws_instance" "private_srv" {
    count                  = var.private_count
    ami                    = data.aws_ami.ubuntu.id
    instance_type          = var.instance_type
    iam_instance_profile   = var.instance_iam
    user_data              = file("~/Desktop/education/terraform/Terraform_modules/ec2/web_srv.sh")

    network_interface {
      network_interface_id = element(aws_network_interface.srv_private[*].id,count.index)
      device_index = 0
    }

    root_block_device {
      volume_size = 8
    }
    
}