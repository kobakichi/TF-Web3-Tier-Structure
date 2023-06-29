variable "prefix" {
  type = string
}

variable "vpc_cidr" {
  type        = string
  description = "vpc cidrblock"
}

variable "availability_zones" {
  type = list(string)
}

variable "az_place" {
  type = list(string)
}