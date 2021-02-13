resource "aws_lb" "loadbalance" {
  name            = "Terraform-LoadBalance"
  security_groups = [aws_security_group.loadbalance.id]
  subnets         = [aws_subnet.public1.id, aws_subnet.public2.id]

  tags = {
    "Name" = "TfLoadBalance"
  }
}

resource "aws_lb_target_group" "tg" {
  name     = "TfLoadBalance"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc.id

  health_check {
    path              = "/"
    healthy_threshold = 2
  }
}

resource "aws_lb_listener" "lbl" {
  load_balancer_arn = aws_lb.loadbalance.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}