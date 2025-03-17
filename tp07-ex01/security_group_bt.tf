resource "aws_security_group" "bastion" {
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.main.id
}

resource "aws_vpc_security_group_ingress_rule" "allow_SSH_bastion" {
  security_group_id = aws_security_group.bastion.id
  cidr_ipv4         = "15.237.202.249/32"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4_bastion" {
  security_group_id = aws_security_group.bastion.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

