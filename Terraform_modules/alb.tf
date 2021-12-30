resource "aws_lb" "alb" {
  name               = "alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.sg-alb.id]
  subnets            = [module.vpc.public_subnet_ids[0],module.vpc.public_subnet_ids[1]]
}

resource "aws_lb_target_group" "ftarget" {
  name     = "first-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_cidr_id
  health_check {
    path   = "/"
  }
}

resource "aws_lb_target_group" "starget" {
  name     = "second-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_cidr_id 
  health_check {
    path   = "/phpmyadmin"
  }
}


resource "aws_lb_target_group_attachment" "web_srv_1" {
  count            = length(module.web[0].aws_instance_id)
  target_group_arn = aws_lb_target_group.ftarget.arn
  target_id        = element(module.web[0].aws_instance_id,count.index)
  port             = 80
}

resource "aws_lb_target_group_attachment" "web_srv_2" {
  count            = length(module.web[1].aws_instance_id)
  target_group_arn = aws_lb_target_group.ftarget.arn
  target_id        = element(module.web[1].aws_instance_id,count.index)
  port             = 80
}

resource "aws_lb_target_group_attachment" "db_server" {
  count            = length(module.db[0].aws_instance_id)
  target_group_arn = aws_lb_target_group.starget.arn
  target_id        = element(module.db[0].aws_instance_id,count.index)
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