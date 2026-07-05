resource "aws_vpc" "eks_vpc" {
    cidr_block = var.cidr_block
    tags = {
        name= var.tags["name"]
        project= "EKS-Cluster"
    }
    instance_tenancy = "default"
    enable_dns_hostnames = true
    enable_dns_support   = true  
}

resource "aws_subnet" "publicsubnet" {
    count =2
    vpc_id = aws_vpc.eks_vpc.id
    cidr_block = var.public_subnet_cidrs[count.index]
    availability_zone = element(data.aws_availability_zones.available.names, count.index)
    tags = {
        name = "${var.tags["name"]}-public-subnet-${count.index + 1}"
        Tier = "public"
    }
    map_public_ip_on_launch = "true"
}


resource "aws_subnet" "privatesubnet" {
    count =2
    vpc_id = aws_vpc.eks_vpc.id
    cidr_block = var.private_subnet_cidrs[count.index]
    availability_zone = element(data.aws_availability_zones.available.names, count.index)
    tags = {
        name = "${var.tags["name"]}-private-subnet-${count.index + 1}"
        Tier = "private"
    }
    map_public_ip_on_launch = "false"
}

