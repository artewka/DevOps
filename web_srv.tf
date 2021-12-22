terraform {
  required_providers {
    cloudflare = {
      source = "cloudflare/cloudflare"
      version = "~> 3.0"
    }

    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}


provider "aws" {
   access_key = ""
   secret_key = ""
   region     = "eu-central-1"
}

provider "cloudflare" {
   email = ""
   api_key = ""
   version = "~> 3.0"
}


#-----------------------------------------NETWORK-----------------------------------#
resource "aws_vpc" "Vpc_Ter" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    "Name" = "Vpc_Ter"
  }
}

resource "aws_internet_gateway" "gwT" {
  vpc_id = aws_vpc.Vpc_Ter.id

  tags = {
    Name = "Gateway_from_Terraform"
  }
}

resource "aws_route_table" "route_public" {
  vpc_id = aws_vpc.Vpc_Ter.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gwT.id
  }

  tags = {
    Name = "public_sub"
  }
}

resource "aws_subnet" "Public1" {
  vpc_id                  = aws_vpc.Vpc_Ter.id
  cidr_block              = "10.0.100.0/24"
  availability_zone       = "eu-central-1a"
  map_public_ip_on_launch = "true"

  tags = {
    Name = "Public_subnet1"
  }
}

resource "aws_subnet" "Public2" {
  vpc_id                  = aws_vpc.Vpc_Ter.id
  cidr_block              = "10.0.200.0/24"
  availability_zone       = "eu-central-1b"
  map_public_ip_on_launch = "true"

  tags = {
    Name = "Public_subnet2"
  }
}

resource "aws_subnet" "Private1" {
  vpc_id                 = aws_vpc.Vpc_Ter.id
  cidr_block             = "10.0.110.0/24"
  availability_zone      = "eu-central-1a"
  
  tags = {
    Name = "Private_subnet1"
  }
}

resource "aws_route_table_association" "publ" {
  subnet_id      = aws_subnet.Public1.id
  route_table_id = aws_route_table.route_public.id
}

resource "aws_route_table_association" "publ2" {
  subnet_id      = aws_subnet.Public2.id
  route_table_id = aws_route_table.route_public.id
}

/*
resource "aws_nat_gateway" "nat-get" {
  subnet_id     = aws_subnet.Private1.id

  tags = {
    Name = "gw NAT"
  }
  depends_on = [aws_internet_gateway.gwT]
}
*/


#--------------------------------------EC-2--------------------------------------------#
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

resource "aws_network_interface" "web-server" {
  subnet_id       = aws_subnet.Public1.id
  security_groups = [aws_security_group.web.id]
}


resource "aws_network_interface" "web-server2" {
  subnet_id       = aws_subnet.Public2.id
  security_groups = [aws_security_group.web.id]
}

resource "aws_network_interface" "web-server3" {
  subnet_id       = aws_subnet.Private1.id
  security_groups = [aws_security_group.web3.id]
}


resource "aws_instance" "web_Terraform1" {
    ami                    = data.aws_ami.ubuntu.id
    instance_type          = "t2.micro" 
    iam_instance_profile   = "EC2_SSM"
    user_data              = file("web_srv.sh")

    network_interface {
      network_interface_id = aws_network_interface.web-server.id
      device_index = 0
    }

    root_block_device {
      volume_size = 8
    }
    
}

resource "aws_instance" "web_Terraform2" {
    ami                    = data.aws_ami.ubuntu.id
    instance_type          = "t2.micro" 
    iam_instance_profile   = "EC2_SSM"
    user_data              = file("web_srv.sh")

    network_interface {
      network_interface_id = aws_network_interface.web-server2.id
      device_index = 0
    }

    root_block_device {
      volume_size = 8
    }
    
}

resource "aws_instance" "web_Terraform3" {
    ami                    = data.aws_ami.ubuntu.id
    instance_type          = "t2.micro" 
    iam_instance_profile   = "EC2_SSM"
    user_data              = file("web_srv.sh")

    network_interface {
      network_interface_id = aws_network_interface.web-server3.id
      device_index = 0
    }

    root_block_device {
      volume_size = 8
    }
    
}

#--------------------------------------Security-Group--------------------------------------------#
resource "aws_security_group" "web" {
  name        = "allow_ssh"
  description = "Allow ssh inbound traffic"
  vpc_id      = aws_vpc.Vpc_Ter.id


  ingress {
    description      = "SSH from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "HTTP from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_ssh,http"
  }
}

resource "aws_security_group" "web3" {
  name        = "allow_ssh,mysql"
  description = "Allow ssh,mysql inbound traffic"
  vpc_id      = aws_vpc.Vpc_Ter.id


  ingress {
    description      = "SSH from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "MYSQL from VPC"
    from_port        = 3306
    to_port          = 3306
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "HTTP from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }


  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_ssh,mysql,http"
  }
}


resource "aws_security_group" "sg-alb" {
  name        = "ALB_trafic"
  description = "Allow ALB traficc"
  vpc_id      = aws_vpc.Vpc_Ter.id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name    = "ALB_traffic"
  }
}

#--------------------------------------ALB--------------------------------------------#
resource "aws_lb" "alb" {
  name               = "alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.sg-alb.id]
  subnets            = [aws_subnet.Public1.id, aws_subnet.Public2.id]

}


resource "aws_lb_target_group" "ftarget" {
  name     = "first-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.Vpc_Ter.id
  health_check {
    path   = "/"
  }
}

resource "aws_lb_target_group" "starget" {
  name     = "second-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.Vpc_Ter.id
  health_check {
    path   = "/phpmyadmin"
  }
}


resource "aws_lb_target_group_attachment" "attach_srv" {
  target_group_arn = aws_lb_target_group.ftarget.arn
  target_id        = aws_instance.web_Terraform1.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "attach_srv_2" {
  target_group_arn = aws_lb_target_group.ftarget.arn
  target_id        = aws_instance.web_Terraform2.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "attach_srv_3" {
  target_group_arn = aws_lb_target_group.starget.arn
  target_id        = aws_instance.web_Terraform3.id
  port             = 80
}

resource "aws_lb_listener" "first_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ftarget.arn
  }
}

resource "aws_lb_listener" "second_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "8080"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.starget.arn
  }
}

#--------------------------------------CLOUDWATCH--------------------------------------------#
resource "aws_cloudwatch_dashboard" "terraform" {
  dashboard_name = "Dashboard_from_Terraform"

  dashboard_body = <<EOF
{
  "widgets": [
    {
      "type": "metric",
      "x": 0,
      "y": 0,
      "width": 24,
      "height": 12,
      "properties": {
        "metrics": [
        [ 
          "AWS/ApplicationELB", 
          "RequestCount", 
          "AvailabilityZone", 
          "eu-central-1a" 
        ]
      ],
      "region": "eu-central-1",
      "title": "RequestCountfromELB"
      }
    },
    {
      "type": "text",
      "x": 0,
      "y": 7,
      "width": 3,
      "height": 3,
      "properties": {
        "markdown": "Test"
      }
    }
  ]
}
EOF
}


resource "aws_cloudwatch_metric_alarm" "alarm" {
  alarm_name                = "terraform-test"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "2"
  threshold                 = "10"
  alarm_description         = "Request error rate has exceeded 10%"
  insufficient_data_actions = []

  metric_query {
    id          = "e1"
    expression  = "m2/m1*100"
    label       = "Error Rate"
    return_data = "true"
  }

  metric_query {
    id = "m1"

    metric {
      metric_name = "RequestCount"
      namespace   = "AWS/ApplicationELB"
      period      = "120"
      stat        = "Sum"
      unit        = "Count"

      dimensions = {
        LoadBalancer = "alb"
      }
    }
  }

  metric_query {
    id = "m2"

    metric {
      metric_name = "HTTPCode_ELB_5XX_Count"
      namespace   = "AWS/ApplicationELB"
      period      = "120"
      stat        = "Sum"
      unit        = "Count"

      dimensions = {
        LoadBalancer = "alb"
      }
    }
  }
}


#--------------------------------------Cloudlfare--------------------------------------------
resource "cloudflare_record" "console-paas" {
  zone_id = "61de978f47e2d4be9667310317141de8"
  name    = "CNAME from alb"
  value   = "${aws_lb.alb.dns_name}"
  type    = "CNAME"
  proxied = true
}


/*Error: failed to create DNS record: HTTP status 403: You cannot use this API for domains with a .cf, .ga, .gq, .ml, or .tk TLD (top-level domain). 
To configure the DNS settings for this domain, use the Cloudflare Dashboard. (1038)*/
