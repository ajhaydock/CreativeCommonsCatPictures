// find this in the dashboard page for the domain in Cloudflare
variable "cloudflare_zone_id" {
  default = "bcf2464ea80f6c630b5eb08cac4feba8"
}

// create A record for server
resource "cloudflare_record" "A" {
  zone_id  = var.cloudflare_zone_id
  name     = "wg"
  type     = "A"
  ttl      = 600
  proxied  = false
  value    = aws_instance.dwk.public_ip
}

// Can't get AAAA records to work until I can work out how to extract the IPv4 address from the Terraform vars

// create AAAA record for server
#resource "cloudflare_record" "AAAA" {
#  zone_id  = var.cloudflare_zone_id
#  name     = "wg"
#  type     = "AAAA"
#  ttl      = 600
#  proxied  = false
#  value    = aws_instance.dwk.ipv6_addresses[0]
#}