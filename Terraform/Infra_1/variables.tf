data "aws_availability_zones" "available" {
  state = "available"
}

variable "instance_type" {

}

variable "tags" {

}

variable "sg_name" {

}

variable "ingress_rules" {

}

variable "cidr_block" {
  type    = string
  default = "10.0.0.0/16"
}