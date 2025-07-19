variable "aws_region" {
  description = "Región de AWS"
  default     = "us-east-1"
}

variable "vpc_id" {
  description = "ID de la VPC existente"
  type        = string
}

variable "private_subnets" {
  description = "Lista de subnets privadas"
  type        = list(string)
}