output "ami_id" {
  value = data.aws_ami.ubuntu.id
}

output "azs" {
  value = data.aws_availability_zones.azs.*.names
}


