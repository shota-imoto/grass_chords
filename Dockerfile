FROM ruby:2.5.1-alpine

ENV BUNDLER_VERSION=2.1.4

WORKDIR /grasschords

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
    rm -rf /usr/local/bundle/ruby/2.5.0/cache/* && \
    rm -rf /root/.bundle/cache/* && \
    find /usr/lib/node_modules -delete && \
    find /usr/local/bundle/gems/ -name "*.c" -delete && \
    find /usr/local/bundle/gems/ -name "*.o" -delete && \
    apk del --purge libxml2-dev curl-dev make gcc libc-dev g++ linux-headers && \
    bundle exec rails assets:precompile RAILS_ENV=production && \
    find /usr/local/bundle/ruby/2.5.0/gems/sassc-2.3.0 -name "*" -delete

COPY . /grasschords
RUN chmod +x start.sh
CMD ["/grasschords/start.sh"]
