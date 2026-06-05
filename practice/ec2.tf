resource "aws_instance" "cdo-03-instance" {
  ami                         = var.ami
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.cdo-03-public-subnet-a.id
  vpc_security_group_ids      = [aws_security_group.cdo-03-ec2-sg.id]
  key_name                    = aws_key_pair.generated_key.key_name
  associate_public_ip_address = true

  root_block_device {
    volume_size           = 30
    volume_type           = "gp3"
    delete_on_termination = true
  }
  user_data = file("${path.module}/scripts/user_data.sh")
  user_data_replace_on_change = true
  tags = {
    Name = "${var.group_id}-ec2"
  }
}
