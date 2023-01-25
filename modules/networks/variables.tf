variable "vpc_cidr" {
  description = "cidr for vpc"
  type = string
}
variable "public_subnets" {
  type = map
  
}
variable "private_subnets" {
  type = map
}
variable ipv4_cidr_blocks{
  type = string
  default = "0.0.0.0/0"
}
variable public_subnet_nat {

}

variable rt_public_subnets{}
variable rt_private_subnets{}
