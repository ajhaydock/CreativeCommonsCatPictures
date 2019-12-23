FROM registry.gitlab.com/alexhaydock/dockerfiles:jekyll as builder
LABEL maintainer "Alex Haydock <alex@alexhaydock.co.uk>"

COPY . /tmp/darkwebkittens.xyz
WORKDIR /tmp/darkwebkittens.xyz
RUN bundle install
RUN bundle exec jekyll build

FROM nginx:stable-alpine
COPY --from=builder /tmp/darkwebkittens.xyz/_site /usr/share/nginx/html