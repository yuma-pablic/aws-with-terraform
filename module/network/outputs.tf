output "vpd_id" {
  value = aws_vpc.this.id
}
output "vpce_sg" {
  value = aws_security_group.sbcntr-sg-vpce.id
}

output "sg-backend-id" {
  value = aws_security_group.sbcntr-sg-backend.id
}
output "sg-frontend-id" {
  value = aws_security_group.sbcntr-sg-front-container.id
}

output "sg-management-id" {
  value = aws_security_group.sbcntr-sg-management.id
}

output "subnet-private-egress-1a-id" {
  value = aws_subnet.sbcntr-subnet-private-egress-1a.id
}

output "subnet-private-egress-1c-id" {
  value = aws_subnet.sbcntr-subnet-private-egress-1c.id
}

output "aws_lb_target_group.sbcntr-tg-blue.name" {
  value = aws_lb_target_group.sbcntr-tg-blue.name
}

output "aws_lb_target_group.sbcntr-tg-green.name" {
  value = aws_lb_target_group.sbcntr-tg-green.name
}

output "sbcntr-alb-front-arn" {
  value = aws_alb.sbcntr-alb-frontend.arn
}