variable "cidr_block" {
  
}

variable "tags" {

}

data "aws_availability_zones" "available" {
  state = "available"
}

variable "ingress_rules" {

}

variable "sg_name" {

}
