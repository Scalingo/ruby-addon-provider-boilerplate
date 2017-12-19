FROM ruby:2.4.1
MAINTAINER john@scalingo.com
RUN apt-get update && apt-get install -y nodejs

COPY Gemfile Gemfile.lock /usr/src/app/
RUN gem install rerun

WORKDIR /usr/src/app
