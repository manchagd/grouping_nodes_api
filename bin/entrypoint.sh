#!/bin/sh

set -e

if [ -f tmp/pids/server.pid ]; then
  rm tmp/pids/server.pid
fi

until nc -z "$DB_HOST" "$DB_PORT"; do
  sleep 0.5
done

bundle check || bundle install

RAILS_ENV=${RAILS_ENV} bundle exec rake db:create
RAILS_ENV=${RAILS_ENV} bundle exec rake db:migrate

RAILS_ENV=${RAILS_ENV} bundle exec rails s -b 0.0.0.0