# Create a new instance of the latest Ubuntu 18.04 on an
# t2.micro node with an AWS Tag naming it "HelloWorld"

# We configure these using env vars (see ~/.ssh/shell_secrets.sh) so we don't need to do any provider config here
provider "aws" {}
provider "cloudflare" {}

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
  public_key = file(var.SSHPUBKEY)
}

# Look up the AMI ID of the Ubuntu instance we want
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
    # Allow DoT in from anywhere
    from_port   = 853
    to_port     = 853
    protocol    = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 853
    to_port   = 853
    protocol  = "tcp"
    ipv6_cidr_blocks = ["::/0"]
  }

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

# Import the $TF_VAR_SSHKEY env var
variable "SSHKEY" {}

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
    ipv6_address_count = 1

    # Use remote-exec to run a pointless command on the remote server because remote-exec will wait for the
    # server instance to deploy properly, whereas local-exec wouldn't. If we just try to run our Ansible
    # playbook immediately then Vultr probably won't have finished deploying the server before it tries to run.
    provisioner "remote-exec" {
      inline = ["echo Hello_World"]

      connection {
        host        = aws_instance.dwk.public_ip
        type        = "ssh"
        user        = "ubuntu"
        private_key = file(var.SSHKEY)
      }
    }

    provisioner "local-exec" {
        command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u ubuntu --private-key '${var.SSHKEY}' -i '${aws_instance.dwk.public_ip},' ansible-playbook.yml"
    }
}

// find this in the dashboard page for the domain in Cloudflare
variable "cloudflare_zone_id" {
  default = "bcf2464ea80f6c630b5eb08cac4feba8"
}

// create A record for server
resource "cloudflare_record" "A" {
  zone_id  = var.cloudflare_zone_id
  name     = "dns"
  type     = "A"
  ttl      = 600
  proxied  = false
  value    = aws_instance.dwk.public_ip
}

// create AAAA record for server
#resource "cloudflare_record" "AAAA" {
#  zone_id  = var.cloudflare_zone_id
#  name     = "dns"
#  type     = "AAAA"
#  ttl      = 600
#  proxied  = false
#  value    = aws_instance.dwk.ipv6_addresses[0]
#}