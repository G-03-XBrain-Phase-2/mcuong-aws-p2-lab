variable "aws_region" {
  type        = string
  default     = "ap-southeast-1"
  description = "AWS Region"
}

variable "group_id" {
  type        = string
  default     = "cdo-03"
  description = "Group ID"
}

variable "instance_type" {
  type        = string
  default     = "t3.small"
  description = "Instance Type cua EC2"
}

variable "ami" {
  type        = string
  default     = "ami-0543dbdaf4e114be7"
  description = "AMI ID cho EC2"
}

variable "react_image" {
  type        = string
  default     = "manhcuong139/portfolio:latest"
  description = "Docker image path for React Vite app"
}

