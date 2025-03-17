resource "aws_security_group" "nextcloud" {
  description = "Allow SSH inbound traffic from bastion"
  vpc_id      = aws_vpc.main.id
}

resource "aws_vpc_security_group_ingress_rule" "allow_SSH_nextcloud" {
  security_group_id = aws_security_group.nextcloud.id
  #cidr_ipv4         = "10.0.4.88/32"
  referenced_security_group_id = aws_security_group.bastion.id
  from_port                    = 22
  to_port                      = 22
  ip_protocol                  = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "allow_HTTP_nextcloud" {
  security_group_id            = aws_security_group.nextcloud.id
  referenced_security_group_id = aws_security_group.alb.id
  from_port                    = 80
  to_port                      = 80
  ip_protocol                  = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "allow_RDS_nextcloud" {
  security_group_id            = aws_security_group.nextcloud.id
  referenced_security_group_id = aws_security_group.nextcloud.id
  from_port                    = 3306
  to_port                      = 3306
  ip_protocol                  = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "allow_NFS_nextcloud" {
  security_group_id            = aws_security_group.nextcloud.id
  referenced_security_group_id = aws_security_group.nextcloud.id
  from_port                    = 2049
  to_port                      = 2049
  ip_protocol                  = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.nextcloud.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}