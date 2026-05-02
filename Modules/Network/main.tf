resource "aws_internet_gateway" "IGW" {
    vpc_id = var.vpc_id
    tags = {
        name = "${var.tags["name"]}-IGW"
    }
}

resource "aws_route_table" "publicRT" {
    vpc_id = var.vpc_id
    tags = {
        name = "${var.tags["name"]}-public-RT"
    }

    route {
        cidr_block      = "0.0.0.0/0"
        gateway_id      = aws_internet_gateway.IGW.id
    }
}

resource "aws_route_table_association" "publicRTassoc" {
    count          = 2
    subnet_id      = var.public_subnet_ids[count.index]
    route_table_id = aws_route_table.publicRT.id
}



