# darkwebkittens.xyz

http://kitten3wusb6j26ukqae5cioarrademwlaoa5sria4uporcstbkdflid.onion

This domain and site are a tongue-in-cheek reference to Ethan Zuckerman's [Cute Cat Theory](https://en.wikipedia.org/wiki/Cute_cat_theory_of_digital_activism) of digital activism. The theory suggests that when more people start using a particular service (in this case Tor Onion Services) for mundane activities like sharing pictures of kittens, rather than solely for activism or avoiding censorship, that service becomes more resistant to government interference or censorship.

I use this so that I have a domain where I can experiment with new things (automation, deployment, DNS/domain config, encryption, etc.) without breaking anything important when I get something wrong.

If you're particularly interested, you can deploy your own version of this site by either building from this repo using the `Makefile`, or deploying the pre-built Docker container from GitLab's container registry.

### Technologies Used
This repo is the culmination of experimentation with lots of different tools and technologies:
* **Jekyll / Ruby** - For building the static site.
* **Tor Onion Services** - For hosting the 'Darkweb' portion of this project.
* **Docker** - Site container.
* **GitLab CI** - Automated container builds and testing.
* **Terraform** - Automated infrastructure deployment.
* **Ansible** - Configuration management of deployed infrastructure.
* **AWS** - My current platform for testing infrastructure automation.
* **DNS** - Cloudflare Managed DNS in particular, with automated management by both Terraform and Ansible.
* **DNS-over-HTTPS** - This runs a public DoH resolver (for now; will remove if it gets abused).
* **NGINX** - Used as a TLS 1.3 terminator for DoH, including some of the more complex config like `stream{}` blocks and JS modules.
* **Pi-Hole** - Deployed via Docker for filtering on the DoH instance.

### Deployment:
To quickly deploy a build version of this container, you can run a Docker command like this:
```sh
docker run --rm -it -p "80:80/tcp" "registry.gitlab.com/alexhaydock/darkwebkittens.xyz:$(uname -m)"
```

This command will pull the relevant image depending on your architecture. Regular `x86_64` images are automatically built by GitLab CI, but I also periodically push manual `armv7l` and `aarch64` builds using some Raspberry Pi systems which I own.

### Develop Locally
This runs a container with Jekyll which will listen on `localhost:4000` and will update live as you change aspects of the site design.
```sh
make test
```

### Build & Push to GitLab
Largely for my own use, this will build a static version of the site with Jekyll, and push it to a GitLab container registry.
```sh
make build
```

### Running Terraform Plan
Again, for my own use, I use a `Makefile` to make my life easier so I can pass the relevant environment variables to Terraform.
* `terraform plan` --> BECOMES --> `make plan`
* `terraform apply` --> BECOMES --> `make apply`
* `terraform destroy` --> BECOMES --> `make destroy`

### Updating AWS Security Groups
If your public IP changes, or you move networks and you need to allow SSH access into the EC2 instance from your current IP, you can just run `make apply` again to update the security group without destroying the EC2 instance.
