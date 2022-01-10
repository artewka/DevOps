resource "aws_security_group" "public_srv" {
  name        = "${var.environment}-rules to open ports for public_srv"
  description = "Allow http inbound traffic"
  vpc_id      = aws_vpc.Vpc_Ter.id

  dynamic "ingress" {
    for_each = ["80","443","22"]
    content {
      from_port        = ingress.value
      to_port          = ingress.value
      protocol         = "tcp"
      cidr_blocks      = [var.route_public_cidr_block]
    }
  }
    egress {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  
  tags = {
    Name = "allow http,https"
  }
}

resource "aws_security_group" "private_srv" {
  name        = "${var.environment}-allow_ssh,mysql"
  description = "Allow ssh,mysql inbound traffic"
  vpc_id      = aws_vpc.Vpc_Ter.id


dynamic "ingress" {
    for_each = ["80","3306","22"]
    content {
      from_port        = ingress.value
      to_port          = ingress.value
      protocol         = "tcp"
      cidr_blocks      = [var.route_public_cidr_block]
    }
}

    egress {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }

  tags = {
    Name = "allow mysql,http"
  }
}