resource "aws_lb" "cdo-03-alb" {
  name               = "${var.group_id}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.cdo-03-alb-sg.id]
  subnets            = [aws_subnet.cdo-03-public-subnet-a.id, aws_subnet.cdo-03-public-subnet-b.id]

  tags = {
    Name = "${var.group_id}-alb"
  }
}

resource "aws_lb_target_group" "ec2_tg" {
  name     = "${var.group_id}-ec2-tg"
  port     = 30080
  protocol = "HTTP"
  vpc_id   = aws_vpc.cdo-03-vpc.id

  health_check {
    path                = "/"
    port                = "30080"
    protocol            = "HTTP"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.cdo-03-alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ec2_tg.arn
  }
}

resource "aws_lb_target_group_attachment" "ec2_attachment" {
  target_group_arn = aws_lb_target_group.ec2_tg.arn
  target_id        = aws_instance.cdo-03-instance.id
  port             = 30080
}
