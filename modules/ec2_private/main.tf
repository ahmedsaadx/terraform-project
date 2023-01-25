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
    filter {
        name   = "architecture"
        values = ["x86_64"]
    }
    owners = ["099720109477"] 

}

resource "aws_instance" "ec2_template_private" {
  ami = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  subnet_id = var.subnet_id
  associate_public_ip_address = var.public_
  vpc_security_group_ids = [aws_security_group.ec2-sg-2.id]
  key_name = var.key_name
  user_data = var.user_data
  
}
resource "aws_security_group" "ec2-sg-2" {
  vpc_id = var.vpc_id
  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = [var.ipv4_cidr_blocks]
  }
  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = [var.ipv4_cidr_blocks]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = [var.ipv4_cidr_blocks]
  }
  tags = {
    Name = "allow_ssh_http"
  }
}

