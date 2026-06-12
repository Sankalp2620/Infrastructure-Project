resource "aws_vpc" "EKS_VPC" {
    cidr_block = var.cidr_block
    tags = {
        name= var.tags["name"]
    }
    instance_tenancy = "default"
    enable_dns_hostnames = true
}

resource "aws_subnet" "publicsubnet" {
    count =2
    vpc_id = aws_vpc.EKS_VPC.id
    cidr_block = var.public_subnet_cidrs[count.index]
    availability_zone = element(data.aws_availability_zones.available.names, count.index)
    tags = {
        name = "${var.tags["name"]}-public-subnet-${count.index + 1}"
    }
    map_public_ip_on_launch = "true"

}

resource "aws_subnet" "privatesubnet" {
    count =2
    vpc_id = aws_vpc.EKS_VPC.id
    cidr_block = var.private_subnet_cidrs[count.index]
    availability_zone = element(data.aws_availability_zones.available.names, count.index)
    tags = {
        name = "${var.tags["name"]}-private-subnet-${count.index + 1}"
    }
    map_public_ip_on_launch = "false"

}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.EKS_VPC.id
  tags   = var.tags
}

resource "aws_eip" "nat_eip" {
  domain = "vpc"
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.publicsubnet[0].id
  tags          = var.tags
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.EKS_VPC.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.EKS_VPC.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }
}

resource "aws_route_table_association" "public" {
  count          = 2
  subnet_id      = aws_subnet.publicsubnet[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  count          = 2
  subnet_id      = aws_subnet.privatesubnet[count.index].id
  route_table_id = aws_route_table.private.id
}

data "aws_availability_zones" "available" {
    state = "available"
}
