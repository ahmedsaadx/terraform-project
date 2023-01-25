output "Load_Balancer_DNS" {

  value = aws_lb.alb.dns_name

}