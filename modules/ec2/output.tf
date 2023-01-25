output "instance_id" {
  value = tolist(aws_instance.ec2_template[*].id)
}
output "public_ip" {
  value = aws_instance.ec2_template.public_ip
  
}
output "private_ip"{
  value = aws_instance.ec2_template.private_ip
}