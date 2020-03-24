// Create new security group
variable "security_group_name" {
  type    = string
  default = "tf_dwk_sg"
}

resource "aws_security_group" "securitygroup" {
  name        = var.security_group_name
  description = "Terraform dwk Security Group"

  ingress {
    # Allow SSH in from anywhere
    # TODO: Update!
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    # Allow HTTPS for DoH (we're not even bothering with opening HTTP ports) in from anywhere
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    # Allow WireGuard from anywhere (TCP)
    from_port        = 51820
    to_port          = 51820
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    # Allow WireGuard from anywhere (UDP)
    from_port        = 51820
    to_port          = 51820
    protocol         = "udp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  # DoT isn't set up yet
  #  ingress {
  #    # Allow DoT in from anywhere
  #    from_port   = 853
  #    to_port     = 853
  #    protocol    = "tcp"
  #    cidr_blocks     = ["0.0.0.0/0"]
  #    ipv6_cidr_blocks = ["::/0"]
  #  }

  # Allow egress traffic to anywhere
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}