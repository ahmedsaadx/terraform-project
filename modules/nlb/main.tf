resource "aws_lb" "network_lb" {
  name               = var.name
  internal           = true
  load_balancer_type = "network"
  subnets            = var.subnets
}


resource "aws_lb_listener" "nlb_listener" {
  load_balancer_arn = aws_lb.network_lb.arn

  protocol = "TCP"
  port     = "80"

  default_action {
    type             = "forward"
    target_group_arn = var.target_group_arn
  }
}
resource "aws_security_group" "nlb_sg" {
  vpc_id = var.vpc_id
  ingress {
  
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
   
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    
  }

  tags = {
    Name = "allow_ssh_http"
  }
}