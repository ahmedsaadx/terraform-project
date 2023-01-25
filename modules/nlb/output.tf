output "Load_Balancer_DNS" {

  value = aws_lb.network_lb.dns_name

}