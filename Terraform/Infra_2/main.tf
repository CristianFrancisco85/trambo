provider "aws" {
  region = "us-west-2"
}

terraform {
  backend "s3" {
    bucket = "trambo-training"
    key    = "backends/state2"
    region = "us-west-2"
  }
}

module "myvpc" {

  source  = "./modules/VPC"
  cidr_block = var.cidr_block
  tags = var.tags
  sg_name = var.sg_name
  ingress_rules = var.ingress_rules

}

module "training_instance-module" {

  source        = "./modules/EC2"
  instance_type = var.instance_type
  tags          = var.tags
  subnet_id     = module.myvpc.public_subnets[0]
  security_groups = [module.myvpc.security_group_id]
  depends_on = [
    module.myvpc
  ]

}
