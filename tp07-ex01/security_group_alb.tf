resource "aws_security_group" "alb" {
  vpc_id = aws_vpc.main.id

  ingress {
    cidr_blocks = ["80.9.122.145/32"]
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}