# darkwebkittens.xyz

http://kitten3wusb6j26ukqae5cioarrademwlaoa5sria4uporcstbkdflid.onion

This domain and site are a tongue-in-cheek reference to Ethan Zuckerman's [Cute Cat Theory](https://en.wikipedia.org/wiki/Cute_cat_theory_of_digital_activism) of digital activism. The theory suggests that when more people start using a particular service (in this case Tor Onion Services) for mundane activities like sharing pictures of kittens, rather than solely for activism or avoiding censorship, that service becomes more resistant to government interference or censorship.

I use this so that I have a domain where I can experiment with new things (automation, deployment, DNS/domain config, encryption, etc.) without breaking anything important when I get something wrong.

If you're particularly interested, you can deploy your own version of this site by either building from this repo using the `Makefile`, or deploying the pre-built Docker container from GitLab's container registry.

### Test Locally
```sh
make test
```

### Build & Push to GitLab
```sh
make build
```

### Deployment (x86_64):
```sh
docker run --rm -it -p "80:80/tcp" "registry.gitlab.com/alexhaydock/darkwebkittens.xyz"
```

### Deployment (armv7l / aarch64)
```sh
docker run --rm -it -p "80:80/tcp" "registry.gitlab.com/alexhaydock/darkwebkittens.xyz:$(uname -m)"
```
