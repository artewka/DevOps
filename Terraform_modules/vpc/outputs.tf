output "public_subnet_ids" {
  description = "subnet ID"
  value       = aws_subnet.Public[*].id
}

output "private_subnet_ids" {
  description = "subnet ID"
  value       = aws_subnet.Private[*].id
}

output "vpc_cidr_id" {
  value       = aws_vpc.Vpc_Ter.id
}

output "sg_public" {
  value = aws_security_group.web_srv.id
}

output "sg_private" {
  value = aws_security_group.db_srv.id
}

output "bastion" {
  value = aws_security_group.bastion.id
}