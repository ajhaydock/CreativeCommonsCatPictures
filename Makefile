.PHONY = test build apply plan destroy
ARCH := $(shell uname -m)

# ifeq statements *must not be indented* in Makefile otherwise it all breaks

test:
	docker run --rm -it --name "jekyll-test" -v "$(shell pwd)/:/opt/www/:z" -p "127.0.0.1:4000:4000/tcp" --workdir /opt/www registry.gitlab.com/alexhaydock/dockerfiles/jekyll bundle exec jekyll serve -H 0.0.0.0

build:
ifeq ($(ARCH),x86_64)
	echo "This build script is designed for systems other than x86_64. Those builds are handled automatically by GitLab CI."
else
	docker build --no-cache -t registry.gitlab.com/alexhaydock/darkwebkittens.xyz:${ARCH} .
	docker push registry.gitlab.com/alexhaydock/darkwebkittens.xyz:${ARCH}
endif

# Lazy commands to pass the env vars we need to Terraform so we can add our current public IP to the AWS security group.
# We just add the /32 to the end of the string here. It's lazy, sure but Terraform wants proper CIDR notation and this is
# the easiest way I could think to do it.
apply:
	export TF_VAR_PUBIP="$(shell wget -qO- ifconfig.co)/32" && terraform apply

plan:
	export TF_VAR_PUBIP="$(shell wget -qO- ifconfig.co)/32" && terraform plan

destroy:
	export TF_VAR_PUBIP="$(shell wget -qO- ifconfig.co)/32" && terraform destroy
