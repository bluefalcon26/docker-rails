#!/bin/sh

usermod -u ${LOCAL_USER_ID} rails
groupmod -g ${LOCAL_GROUP_ID} rails

chown -R rails:rails /home/rails
chown -R rails:rails .

exec gosu rails bash -c "source /home/rails/.rvm/scripts/rvm && rvm use @railsLatest && bundle && rake db:migrate && rake assets:precompile && rm -rf tmp && rails s"

