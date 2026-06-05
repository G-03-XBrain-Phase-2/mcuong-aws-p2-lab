resource "random_id" "key_suffix" {
  byte_length = 4
}

resource "tls_private_key" "ec2_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = "cdo-03-key-${random_id.key_suffix.hex}"
  public_key = tls_private_key.ec2_key.public_key_openssh
}

resource "local_file" "private_key" {
  content         = tls_private_key.ec2_key.private_key_pem
  filename        = "${path.module}/cdo-03-key.pem"
  file_permission = "0600"
}
