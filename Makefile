ARCH := $(shell uname -m)

# ifeq statements *must not be indented* in Makefile otherwise it all breaks

test:
	docker run --rm -it --name "jekyll-test" -v "$(shell pwd)/:/opt/www/:z" -p "127.0.0.1:4000:4000/tcp" --workdir /opt/www registry.gitlab.com/alexhaydock/dockerfiles:jekyll bundle exec jekyll serve -H 0.0.0.0

build:
ifeq ($(ARCH),x86_64)
	echo "This build script is designed for systems other than x86_64. Those builds are handled automatically by GitLab CI."
else
	docker build --no-cache -t registry.gitlab.com/alexhaydock/darkwebkittens.xyz:${ARCH} .
	docker push registry.gitlab.com/alexhaydock/darkwebkittens.xyz:${ARCH}
endif
