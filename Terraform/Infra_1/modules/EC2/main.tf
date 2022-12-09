data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}

resource "tls_private_key" "pk" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "kp" {

  key_name   = "myKey"
  public_key = tls_private_key.pk.public_key_openssh
}

resource "aws_instance" "instance_training" {

  ami             = data.aws_ami.ubuntu.id
  instance_type   = var.instance_type
  tags            = var.tags
  subnet_id       = var.subnet_id
  security_groups = var.security_groups
  key_name        = aws_key_pair.kp.key_name

}