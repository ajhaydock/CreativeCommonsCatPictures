# Create a new instance of the latest Ubuntu 18.04 on an
# t2.micro node with an AWS Tag naming it "HelloWorld"

# We configure AWS using env vars (see ~/.ssh/shell_secrets.sh) so we don't need to do any provider config here
provider "aws" {}

// This var holds our public IP so we can configure the security groups correctly.
// We export this from the command line when running the Terraform plan.
variable "PUBIP" {}

variable "security_group_name" {
  type    = string
  default = "tf_dwk_sg"
}

# Associate pubkey with AWS account (currently just using ~/.ssh/id_ed25519)
resource "aws_key_pair" "keypair" {
  key_name   = "terraform-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDQ8nVu4khdWvAQjmpMXhTqBUaxOd2mItwJQl+slJnMYEJ7agCg8DsAhAsRaCeMplPDadkZaRtd9V5kUZYfeH5+zMpTuhubPjcd3u2UM5hRIkhxuoQU/P9g70KpfePinhukX9GUa4wip6RapZhHDWJeTuAErbvsHj+7dLVDc9o8B+Wyjn1P1Inm7Tmd8odfDdbtb2WQhJUvRAlWxsuvwfxX7Q5BwgQKrjNuuU6NufZn2sb3SHL80fOWzWGDH4uKG6rKN7OVbKcWIOyAmhoMmLNMSyrRrb8W0/1BFRgwR3f4V91Oej4JGf0hIoDhWLlT50gD+6CRWjgP2FhC1I8W8gWVBOVlFEmGaa+hSGOiqccVXGPTEoZCrsJRb9qABPM2ZDTLov4LTUvoq0BoUgAcd2Xsv9ZnOeHPFojKAbNGX8AsBVXXaiaMmw9GUdsd+oJG0v/neWwrzml0BeOuXoRQqG3bAaFbgzz6aOdg+y1w5tMeerPmPKsSTSS/uDTy2hKXnKPvOlYtTPS5cBnTwGKQLzJRdoLxo7SoUHZ0z1+r7QB7fwnJLT1d+AuCm9/KRo+tvxkxiguCZcA8fEuY7+od6/93mn7LeUDT33SNplk9xqxG938DoUvEeep0aOz6i34LwpB90Ttl8uA258mbhuJZu7h1nEfUy08l+F1yDkhQcnz2uQ== null@null"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
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
    # Allow HTTP in from anywhere
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

# The second variable on the first line here is the name that *Terraform* uses internally
# when storing state in the .tfstate files. It's not going to show up in the AWS console.
resource "aws_instance" "dwk" {
    # This AMI is for Ubuntu Server 18.04 
    ami = data.aws_ami.ubuntu.id
    instance_type = "t2.micro"
    # Assign the SSH key we defined earlier to this instance
    key_name = "terraform-key"
    tags = {
        Name = "dwk"
    }
    security_groups = [var.security_group_name]

    # Here, we tell Terraform to call up Ansible after waiting 5 min for EC2 instance to start.
    provisioner "local-exec" {
        command = "sleep 300 && ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u ubuntu --private-key ~/.ssh/id_rsa_AWS -i '${aws_instance.dwk.public_ip},' ansible-playbook.yml"
    }
}