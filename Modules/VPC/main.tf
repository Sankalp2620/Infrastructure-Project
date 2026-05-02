resource "aws_vpc" "EKS_VPC" {
    cidr_block = var.cidr_block
    tags = {
        name= var.tags["name"]
    }
    instance_tenancy = "default"
    enable_dns_hostnames = "true"
}

resource "aws_subnet" "publicsubnet" {
    count =2
    vpc_id = aws_vpc.EKS_VPC.id
    cidr_block = cidrsubnet(aws_vpc.EKS_VPC.cidr_block, 8, count.index)
    availability_zone = element(data.aws_availability_zones.available.names, count.index)
    tags = {
        name = "${var.tags["name"]}-public-subnet-${count.index + 1}"
    }
    map_public_ip_on_launch = "true"

}

resource "aws_subnet" "privatesubnet" {
    count =2
    vpc_id = aws_vpc.EKS_VPC.id
    cidr_block = cidrsubnet(aws_vpc.EKS_VPC.cidr_block, 4, count.index + 2)
    availability_zone = element(data.aws_availability_zones.available.names, count.index)
    tags = {
        name = "${var.tags["name"]}-private-subnet-${count.index + 1}"
    }
    map_public_ip_on_launch = "false"

}

data "aws_availability_zones" "available" {
    state = "available"
}


