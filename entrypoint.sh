#!/bin/sh
set -e
cd /home/git/gitlab
bundle install
sudo -u git rails generate mousetrap:install
sudo -u git yarn install --production --pure-lockfile
sudo npm install -g coffeescript
#sudo -u git -H bundle exec rake gitlab:check RAILS_ENV=production SANITIZE=true
sudo -u git bundle exec rake gitlab:shell:install RAILS_ENV=production SKIP_STORAGE_VALIDATION=true
sudo -u git bundle exec rake "gitlab:workhorse:install[/home/git/gitlab-workhorse]" RAILS_ENV=production
sudo -u git bundle exec rake gitlab:setup RAILS_ENV=production
#sudo -u git bundle exec rake "gitlab:gitaly:install[/home/git/gitaly]" RAILS_ENV=production
sudo -u git bundle exec rake gettext:compile RAILS_ENV=production
sudo -u git bundle exec rake gitlab:assets:compile RAILS_ENV=production NODE_ENV=production
sudo -u git /etc/init.d/gitlab start

