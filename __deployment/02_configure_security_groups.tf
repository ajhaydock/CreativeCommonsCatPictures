// This var holds our public IP so we can configure the security groups correctly.
// We export this from the command line when running the Terraform plan.
variable "PUBIP" {}

// Create new security group
variable "security_group_name" {
  type    = string
  default = "tf_dwk_sg"
}

resource "aws_security_group" "securitygroup" {
  name        = var.security_group_name
  description = "Terraform dwk Security Group"

  ingress {
    # Allow SSH in from just my machine
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    # Needs to be passed in with a PUBIP env var
    cidr_blocks = [var.PUBIP]
  }

  ingress {
    # Allow HTTPS for DoH (we're not even bothering with opening HTTP ports) in from anywhere
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    # Allow WireGuard from anywhere
    from_port   = 51820
    to_port     = 51820
    protocol    = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 51820
    to_port   = 51820
    protocol  = "-1"
    ipv6_cidr_blocks = ["::/0"]
  }

# DoT isn't set up yet
#  ingress {
#    # Allow DoT in from anywhere
#    from_port   = 853
#    to_port     = 853
#    protocol    = "tcp"
#    cidr_blocks     = ["0.0.0.0/0"]
#  }
#
#  ingress {
#    from_port = 853
#    to_port   = 853
#    protocol  = "tcp"
#    ipv6_cidr_blocks = ["::/0"]
#  }

  # Allow egress traffic to anywhere
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    ipv6_cidr_blocks = ["::/0"]
  }
}