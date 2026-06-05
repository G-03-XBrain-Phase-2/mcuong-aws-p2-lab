output "alb_dns_name" {
  value       = "http://${aws_lb.cdo-03-alb.dns_name}"
  description = "Public URL truy cap web exposed boi ALB"
}

output "ec2_public_ip" {
  value       = aws_instance.cdo-03-instance.public_ip
  description = "Public IP cua EC2 cho SSH debugging"
}

output "ssh_command" {
  value       = "ssh -i cdo-03-key.pem ec2-user@${aws_instance.cdo-03-instance.public_ip}"
  description = "SSH vao EC2 instance"
}
