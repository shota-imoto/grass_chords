FROM ruby:2.5.1
ENV DOCKERIZE_VERSION v0.6.1

RUN apt-get update && \
    apt-get install -y --no-install-recommends\
    nodejs  \
    default-mysql-client  \
    build-essential  \
    wget \
    && wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && rm dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /grasschords

COPY Gemfile /grasschords/Gemfile
COPY Gemfile.lock /grasschords/Gemfile.lock

ENV BUNDLER_VERSION=2.1.4
RUN gem install bundler && bundle install

COPY . /grasschords
