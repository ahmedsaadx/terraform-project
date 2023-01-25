output "vpc_id" {
    value = aws_vpc.vpc-tamplate.id
  
}
output "vpc-arn" {
    value = aws_vpc.vpc-tamplate.arn
}
output "public_subnets" {
    value = tolist(values(aws_subnet.public_subnets)[*].id)
}
output "private_subnets" {
    value = tolist(values(aws_subnet.private_subnets)[*].id)
}
output "nat_id" {
    value = aws_nat_gateway.nat-tamplate.id
}
