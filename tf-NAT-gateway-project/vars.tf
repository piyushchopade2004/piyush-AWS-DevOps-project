variable "vpc_cidr" {
  type = string
}
variable "tag1" {
  type = string
}
variable "vpc_public_cidr" {
  type = string
}
variable "vpc_private_cidr" {
  type = string
}
variable "vpc_private_tag" {
  type = string
}
variable "vpc_public_tag" {
  type = string
}
variable "vpc_igw_tag" {
  type = string
}
variable "ami_public_instance" {
  type = string
}
variable "i-type" {
  type = string
}
variable "api-termn" {
  type = bool
}
variable "role" {
  type = string
}
variable "key_public_instance" {
  type = string
}
variable "key_private_instance" {
  type = string
}
variable "ami_private_instance" {
  type = string
}