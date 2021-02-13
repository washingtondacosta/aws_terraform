variable aws_reg {
  default  = "us-west-2"
}

variable stack {
  description = "this is name for tags"
  default     = "terraform"
}

variable "instance_type" {
  default = "t2.micro"
}

variable username {
  description = "DB username"
}

variable password {
  description = "DB password"
}

variable dbname {
  description = "db name"
}

variable ssh_key {
  default     = "~/.ssh/id_rsa.pub"
  description = "Default pub key"
}

variable ssh_priv_key {
  default     = "~/.ssh/id_rsa"
  description = "Default pub key"
}