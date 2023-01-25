# resource "random_integer" "num" {
#     min=1
#     max=100

# }
# resource "random_shuffle" "az" {
#   input        = ["us-east-1a", "us-east-1c", "us-east-1d", "us-east-1e"]
#   result_count = random_integer.num.result
# }
data "aws_availability_zones" "available" {
  state = "available"
}
resource "aws_vpc" "vpc-tamplate" {
    cidr_block = var.vpc_cidr
    tags ={
        Name = "vpc-1"
    }
}

resource "aws_subnet" "public_subnets"{
    vpc_id = aws_vpc.vpc-tamplate.id
    availability_zone = element(data.aws_availability_zones.available.names,each.key)
    for_each = var.public_subnets
    cidr_block = each.value
    tags = {
        name = each.key
    }
}

resource "aws_subnet" "private_subnets"{
    vpc_id = aws_vpc.vpc-tamplate.id
    availability_zone = element(data.aws_availability_zones.available.names,each.key)
    for_each = var.private_subnets
    cidr_block = each.value
    tags = {
        name = each.key
    }

}



resource "aws_internet_gateway" "igw-tamplate" {
    vpc_id = aws_vpc.vpc-tamplate.id
  
 }

resource "aws_eip" "eip-tamplate" {
    vpc = true
}
resource "aws_nat_gateway" "nat-tamplate" {
    allocation_id = aws_eip.eip-tamplate.id
    subnet_id=var.public_subnet_nat

}
resource "aws_route_table" "route-table-public" {
    vpc_id = aws_vpc.vpc-tamplate.id
    
  route {
    cidr_block = var.ipv4_cidr_blocks
    gateway_id = aws_internet_gateway.igw-tamplate.id
  }
}  

resource "aws_route_table" "route-table-private" {
    vpc_id = aws_vpc.vpc-tamplate.id
    
  route {
    cidr_block = var.ipv4_cidr_blocks
    nat_gateway_id = aws_nat_gateway.nat-tamplate.id
  }
}  
resource "aws_route_table_association" "route-associate-public" {
    count = length(var.rt_public_subnets)
    subnet_id = var.rt_public_subnets[count.index]
    route_table_id = aws_route_table.route-table-public.id
  
}
resource "aws_route_table_association" "route-associate-private" {
    count = length(var.rt_private_subnets)
    subnet_id = var.rt_private_subnets[count.index]
    route_table_id = aws_route_table.route-table-private.id
  
}


