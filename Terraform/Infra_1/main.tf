provider "aws" {
  region = "us-west-2"
}

terraform {
  backend "s3" {
    bucket = "trambo-training"
    key    = "backends/state"
    region = "us-west-2"
  }
}

module "vpc" {

  source  = "terraform-aws-modules/vpc/aws"
  version = "3.18.1"

  name = "training-vpc"
  cidr = "10.0.0.0/16"

  azs             = [data.aws_availability_zones.available.names[0]]
  private_subnets = [cidrsubnet(var.cidr_block, 8, 0)]
  public_subnets  = [cidrsubnet(var.cidr_block, 8, 1)]
  
  tags = var.tags

}

resource "aws_security_group" "security_group_training" {

  name        = var.sg_name
  vpc_id      = module.vpc.vpc_id

  dynamic "ingress" {  
    for_each = var.ingress_rules  
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

}


module "training_instance-module" {

  source        = "./modules/EC2"
  instance_type = var.instance_type
  tags          = var.tags
  ingress_rules = var.ingress_rules
  subnet_id     = module.vpc.public_subnets[0]
  security_groups = [aws_security_group.security_group_training.id]
  
}
