.PHONY = apply plan destroy

# Lazy commands to pass the env vars we need to Terraform so we can add our current public IP to the AWS security group.
# We just add the /32 to the end of the string here. It's lazy, sure but Terraform wants proper CIDR notation and this is
# the easiest way I could think to do it.
#
# We use curl -4 now to force IPv4 so that we don't get an IPv6 address returned here.
apply:
	export TF_VAR_PUBIP="$(shell curl -4 --silent ifconfig.co)/32" && export TF_VAR_SSHKEY="/home/a/.ssh/id_rsa_AWS" && export TF_VAR_SSHPUBKEY="/home/a/.ssh/id_rsa_AWS.pub" && terraform apply

plan:
	export TF_VAR_PUBIP="$(shell curl -4 --silent ifconfig.co)/32" && export TF_VAR_SSHKEY="/home/a/.ssh/id_rsa_AWS" && export TF_VAR_SSHPUBKEY="/home/a/.ssh/id_rsa_AWS.pub" && terraform plan

destroy:
	export TF_VAR_PUBIP="$(shell curl -4 --silent ifconfig.co)/32" && export TF_VAR_SSHKEY="/home/a/.ssh/id_rsa_AWS" && export TF_VAR_SSHPUBKEY="/home/a/.ssh/id_rsa_AWS.pub" && terraform destroy