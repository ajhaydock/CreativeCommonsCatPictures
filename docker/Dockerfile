FROM registry.gitlab.com/alexhaydock/dockerfiles:jekyll
LABEL maintainer "Alex Haydock <alex@alexhaydock.co.uk>"

# Install Gems for this site with Bundler
COPY Gemfile /tmp/Gemfile
WORKDIR /tmp
RUN bundle install