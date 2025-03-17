resource "aws_lb" "nextcloud" {
  name               = "nextcloud-alb-${local.user}"
  internal           = false # Doit être false pour être accessible via Internet
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = aws_subnet.public[*].id

  enable_deletion_protection = false
}

resource "aws_lb_target_group" "nextcloud" {
  name     = "nextcloud-${local.user}"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  health_check {
    path                = "/status.php"
    interval            = 38
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 2
  }
}

resource "aws_lb_target_group_attachment" "nextcloud" {
  target_group_arn = aws_lb_target_group.nextcloud.arn
  target_id        = aws_instance.nextcloud.id
  port             = 80
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.nextcloud.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nextcloud.arn
  }
}