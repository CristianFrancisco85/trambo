resource "aws_vpc" "main" {
  cidr_block       = var.cidr_block
  tags = var.tags
}

resource "aws_subnet" "public" {

    count = length(data.aws_availability_zones.available.names)
    vpc_id            = aws_vpc.main.id
    cidr_block        = cidrsubnet(var.cidr_block, 8, count.index)
    availability_zone = data.aws_availability_zones.available.names[count.index]
    map_public_ip_on_launch = true
    tags = {
        Name = "public-${count.index}"
    }
}

resource "aws_subnet" "private" {

    count = length(data.aws_availability_zones.available.names)
    vpc_id            = aws_vpc.main.id
    cidr_block        = cidrsubnet(var.cidr_block, 8, count.index + length(data.aws_availability_zones.available.names) )
    availability_zone = data.aws_availability_zones.available.names[count.index]
    tags = {
        Name = "private-${count.index}"
    }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "rt-public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
}

resource "aws_route_table_association" "rt-public" {
  count = length(data.aws_availability_zones.available.zone_ids)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.rt-public.id
}

resource "aws_route_table" "rt-private" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table_association" "rt-private" {
  count = length(data.aws_availability_zones.available.zone_ids)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.rt-private.id
}

resource "aws_security_group" "security_group_training" {

  name        = var.sg_name
  vpc_id      = aws_vpc.main.id

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