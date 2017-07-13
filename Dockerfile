FROM ruby:2.4-alpine

RUN apk update && apk upgrade && apk add --no-cache tzdata postgresql-dev nodejs postgresql-client imagemagick

RUN mkdir /app
WORKDIR /app

ADD Gemfile /app/Gemfile
ADD Gemfile.lock /app/Gemfile.lock
RUN apk add --virtual .bundle-builddeps alpine-sdk imagemagick-dev \
 && bundle install -j4 --without development test \
 && apk del .bundle-builddeps

ARG RAILS_ENV
EXPOSE 3000

ADD . /app
CMD ['bundle', 'exec', 'rails', '-b', '0.0.0.0', '-e' '${RAILS_ENV}']
