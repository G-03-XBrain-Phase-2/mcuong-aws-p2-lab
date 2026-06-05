data "http" "myip" {
  url = "https://ipv4.icanhazip.com"
}

locals {
  my_ip      = "${chomp(data.http.myip.response_body)}/32"
  is_windows = substr(pathexpand("~"), 0, 1) == "/" ? false : true
}

resource "aws_security_group" "cdo-03-alb-sg" {
  name        = "${var.group_id}-alb-sg"
  description = "Security group cho ALB"
  vpc_id      = aws_vpc.cdo-03-vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.group_id}-alb-sg"
  }
}

resource "aws_security_group" "cdo-03-ec2-sg" {
  name        = "${var.group_id}-ec2-sg"
  description = "Security group cho EC2"
  vpc_id      = aws_vpc.cdo-03-vpc.id
  # MY IP port 22
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [local.my_ip]
  }
  # MY IP port 6443 (K3s API)
  ingress {
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = [local.my_ip]
  }
  # SG cua ALB
  ingress {
    from_port       = 30080
    to_port         = 30080
    protocol        = "tcp"
    security_groups = [aws_security_group.cdo-03-alb-sg.id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.group_id}-ec2-sg"
  }
}
