resource "aws_lb_target_group" "NLB_tg" {
  name     = var.target_name
  port     = 80
  protocol = var.protocol
  vpc_id   = var.vpcid

  health_check {
    enabled  = true
    protocol = var.protocol_heath
  }

  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_alb_target_group_attachment" "tgattachment" {
  count            = length(var.ec2_ids)
  target_group_arn = aws_lb_target_group.NLB_tg.arn
  target_id        = element(var.ec2_ids, count.index)
  port             = 80
  
  depends_on = [
    aws_lb_target_group.NLB_tg
  ]

}