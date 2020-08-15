FROM ruby:2.5.1-alpine

ENV BUNDLER_VERSION=2.1.4

WORKDIR /grasschords

# ARG RAILS_MASTER_KEY
# ENV RAILS_MASTER_KEY dfcf8be3b4d9d26d3dfa1767b4ce5f20

COPY Gemfile /grasschords/Gemfile
COPY Gemfile.lock /grasschords/Gemfile.lock

RUN apk update && \
    apk add --no-cache \
    linux-headers \
    libxml2-dev curl-dev make gcc libc-dev g++ \
    nodejs \
    mariadb-dev \
    tzdata && \
    gem install bundler && \
    bundle install -j4 --without development test && \
    rm -rf /usr/local/bundle/cache/*.gem && \
    rm -rf /root/.bundle/cache/* && \
    rm -rf /usr/local/bundle/ruby/2.5.0/cache/* && \
    find /usr/local/bundle/gems/ -name "*.c" -delete && \
    find /usr/local/bundle/gems/ -name "*.o" -delete && \
    find /usr/lib/node_modules -delete && \
    apk del --purge libxml2-dev curl-dev make gcc libc-dev g++ linux-headers && \
    bundle exec rails assets:precompile RAILS_ENV=production && \
    find /usr/local/bundle/ruby/2.5.0/gems/sassc-2.3.0 -name "*" -delete

COPY . /grasschords
RUN find /grasschords/tmp/cache -name "*" -delete
