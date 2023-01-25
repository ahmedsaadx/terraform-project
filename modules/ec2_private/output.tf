output "private_instance_id" {
  value = tolist(aws_instance.ec2_template_private[*].id)
}
output "private_ip"{
  value = aws_instance.ec2_template_private.private_ip
}