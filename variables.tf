variable "vpc_cidr" {
  description = "cidr for vpc"
  type = string
}
variable "subnet-cidr-1"{
  type = string
}
variable "subnet-cidr-2"{
  type = string
}
variable "subnet-cidr-3"{
  type = string
}
variable "subnet-cidr-4"{
    type = string
}
variable "ipv4_cidr_blocks" {
    type = string
    default = "0.0.0.0/0"
}

variable "instance_type"{

}

variable "key_name"{
    
}
variable "connection_user"{
  
}