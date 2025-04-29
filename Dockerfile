FROM ruby:3.4.2-alpine3.20

# Instala dependencias del sistema
RUN apk add --no-cache \
    build-base \
    postgresql-dev \
    yaml-dev \
    libxml2-dev \
    libxslt-dev \
    nodejs \
    yarn \
    tzdata \
    git \
    vips-dev \
    bash

WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN gem install bundler -v 2.4.9

RUN bundle config build.nokogiri --use-system-libraries
RUN bundle lock --add-platform x86_64-linux

RUN bundle config force_ruby_platform true

RUN bundle install

COPY . ./

EXPOSE 3000

CMD ["/bin/entrypoint.sh"]
