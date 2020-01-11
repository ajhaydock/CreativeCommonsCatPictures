FROM debian as builder
LABEL maintainer "Alex Haydock <alex@alexhaydock.co.uk>"

# Set locale to solve 'US-ASCII' issue
# https://github.com/jekyll/jekyll/issues/4268#issuecomment-167258562
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y locales

RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=en_US.UTF-8

ENV LANG en_US.UTF-8

# Install Jekyll deps
RUN apt-get install -y bundler ruby-dev zlib1g-dev

# Copy site content into container
COPY . /tmp/darkwebkittens.xyz
WORKDIR /tmp/darkwebkittens.xyz

# Install the relevant gems with Bundler and then build the site
RUN bundle install
RUN bundle exec jekyll build

FROM nginx:stable-alpine
COPY --from=builder /tmp/darkwebkittens.xyz/_site /usr/share/nginx/html
