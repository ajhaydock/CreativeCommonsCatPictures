# Look up the AMI ID of the Ubuntu instance we want
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    # Well this isn't LTS but it has the WireGuard package available without needing a PPA
    values = ["ubuntu/images/hvm-ssd/ubuntu-eoan-19.10-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
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
        command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u ubuntu --private-key '${var.SSHKEY}' -i '${aws_instance.dwk.public_ip},' playbook.yml"
    }
}