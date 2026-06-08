# Định nghĩa DB Subnet Group bao gồm cả 2 private subnet
resource "aws_db_subnet_group" "cdo-03-rds-subnet-group" {
  name = "${var.group_id}-rds-subnet-group"
  subnet_ids = [
    aws_subnet.cdo-03-private-subnet-a.id,
    aws_subnet.cdo-03-private-subnet-b.id
  ]

  tags = {
    Name = "${var.group_id}-rds-subnet-group"
  }
}

# Cấu hình RDS Database Instance
resource "aws_db_instance" "cdo-03-rds" {
  allocated_storage = 20
  db_name           = "mydb"
  engine            = "mysql"
  engine_version    = "8.0"
  instance_class    = "db.t3.micro"
  username          = "admin"
  password          = "Manhcuong139" # Khuyến nghị sử dụng Variables hoặc Secret Manager

  db_subnet_group_name   = aws_db_subnet_group.cdo-03-rds-subnet-group.name
  vpc_security_group_ids = [aws_security_group.cdo-03-rds-sg.id]
  skip_final_snapshot    = true
}
