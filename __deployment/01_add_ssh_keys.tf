resource "aws_key_pair" "keypair" {
  key_name   = "terraform-key"
  public_key = file("id_rsa_AWS.pub")
}