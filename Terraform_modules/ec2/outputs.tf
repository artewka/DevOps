output "aws_public_instance_id" {
  value = aws_instance.public_srv[*].id
}

output "aws_private_instance_id" {
  value = aws_instance.private_srv[*].id
}