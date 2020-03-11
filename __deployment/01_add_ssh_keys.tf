# Import the $TF_VAR_SSHPUBKEY shell variable so we can use it to find our SSH key below
variable "SSHPUBKEY" {}

resource "aws_key_pair" "keypair" {
  key_name   = "terraform-key"
  public_key = file(var.SSHPUBKEY)
}