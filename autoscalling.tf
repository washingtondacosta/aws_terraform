resource "aws_launch_configuration" "this" {
  name_prefix                 = "autoscaling-launcher"
  image_id                    = data.aws_ami.ubuntu.id
  instance_type               = "t2.micro"

  depends_on = [
  aws_db_instance.mysql,
  ]

  key_name                    = aws_key_pair.keypair1.key_name
  security_groups             = [aws_security_group.web.id, aws_security_group.autoscaling.id]
  associate_public_ip_address = true

  user_data = file("files/userdata.sh")
}

resource "aws_autoscaling_group" "this" {
  name                      = "terraform-autoscaling"
  vpc_zone_identifier       = [aws_subnet.public1.id, aws_subnet.public2.id]
  launch_configuration      = aws_launch_configuration.this.name
  min_size                  = 2
  max_size                  = 3
  health_check_grace_period = 300
  health_check_type         = "ELB"
  force_delete              = true
  target_group_arns         = [aws_lb_target_group.tg.arn]
  /* enabled_metrics           = [var.enabled_metrics] */
}

resource "aws_autoscaling_policy" "scale-up" {
  name                   = "Scale Up"
  autoscaling_group_name = aws_autoscaling_group.this.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = "1"
  cooldown               = "900"
  policy_type            = "SimpleScaling"
}

resource "aws_autoscaling_policy" "scale-down" {
  name                   = "Scale Down"
  autoscaling_group_name = aws_autoscaling_group.this.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = "-1"
  cooldown               = "900"
  policy_type            = "SimpleScaling"
}