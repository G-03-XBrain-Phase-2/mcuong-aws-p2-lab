variable "aws_region" {
  type        = string
  default     = "ap-southeast-1"
  description = "AWS Region"
}

variable "access_key" {
  type        = string
  description = "AWS Access Key"
}
variable "secret_key" {
  type        = string
  description = "AWS Secret Key"
}

variable "group_id" {
  type        = string
  default     = "cdo-03"
  description = "Group ID"
}

variable "instance_type" {
  type        = string
  default     = "c7i-flex.large"
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

