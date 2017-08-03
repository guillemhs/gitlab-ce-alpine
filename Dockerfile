FROM alpine:3.6
MAINTAINER Guillem <guillem@itnove.com>
ENV RAILS_ENV production
RUN alias cp='cp -iv'
RUN alias mv='mv -iv'
RUN alias rm='rm -iv'
RUN alias less='less -MNE~'
RUN alias more=less
RUN alias ll='ls -lFah --color=auto'
RUN alias mroe=more
RUN alias moer=more
RUN alias mreo=more
RUN alias ..='cd ../'
RUN alias ...='cd ../../'
RUN alias mkdir='mkdir -pv'
RUN alias grep='grep -in'
RUN set -o vi
RUN set -e
RUN apk upgrade --update-cache --available
RUN apk --no-cache add icu-dev cmake krb5-dev libre2-dev git libffi libpq libxml2 libxslt mariadb postgresql
RUN apk --no-cache add ruby ruby-bigdecimal ruby-bundler ruby-io-console ruby-irb ruby-rdoc
RUN apk --no-cache add --virtual build_deps build-base libffi-dev libxml2-dev libxslt-dev linux-headers mariadb-dev postgresql-dev ruby-dev sqlite-dev
RUN apk --no-cache add ca-certificates openssh-server wget vim nano go tzdata sudo yarn python
RUN apk --no-cache add nodejs nodejs-npm && npm install npm@latest -g && npm install -g coffeescript

# Download GitLab
RUN mkdir /home/git
RUN git clone https://gitlab.com/gitlab-org/gitlab-ce.git /home/git/gitlab
RUN gem install bundler --version "1.15.3"
COPY entrypoint.sh /home/git/gitlab

#Settings Timezone
RUN cp /usr/share/zoneinfo/Europe/Brussels /etc/localtime
RUN echo "Europe/Brussels" >  /etc/timezone

RUN git clone https://gitlab.com/gitlab-org/gitaly.git /home/git/gitaly

RUN git clone https://gitlab.com/gitlab-org/gitlab-shell.git /home/git/gitlab-shell
WORKDIR /home/git/gitlab-shell
RUN mv config.yml.example config.yml
RUN ./bin/install
RUN ./bin/compile
RUN addgroup -S git
RUN adduser -S -g git git
CMD chmod +x /home/git/gitlab/entrypoint.sh

WORKDIR /home/git/gitlab
EXPOSE 443 80 5432
RUN mkdir /home/git/repositories
RUN mkdir /etc/default
RUN mkdir /etc/default/gitlab
RUN cp lib/support/init.d/gitlab /etc/init.d/gitlab
RUN cp lib/support/init.d/gitlab.default.example /etc/default/gitlab
RUN cp lib/support/logrotate/gitlab /etc/logrotate.d/gitlab
RUN cp config/gitlab.yml.example config/gitlab.yml
RUN cp config/secrets.yml.example config/secrets.yml
RUN chmod 0600 config/secrets.yml
COPY resque.yml.example config/resque.yml
RUN chmod 0600 config/resque.yml
COPY database.yml.postgres config/database.yml
RUN chmod 0600 config/database.yml
COPY setup.rake lib/tasks/gitlab
RUN chmod 0600 lib/tasks/gitlab/setup.rake
RUN echo "git ALL=(ALL) NOPASSWD:ALL" | sudo tee -a /etc/sudoers
RUN mkdir -p /home/git/.ssh
RUN chmod 700 /home/git/.ssh
CMD chmod ug+rwX,o-rwx /home/git/repositories
CMD chmod -R 777 /home/git/gitlab/config
RUN chown -R git:git /usr/lib/ruby/gems/2.4.0 /usr/bin /home/git/gitlab
RUN chown -R git:git /home/git/gitlab-shell /home/git/.ssh
RUN chown -R git:git /home/git/repositories /home/git/gitlab/config
RUN chmod -R ug+rwX,o-rwx /home/git/repositories
RUN chmod -R ug-s /home/git/repositories
RUN chown root: /usr/bin/sudo
RUN chmod 4755 /usr/bin/sudo


USER git
RUN chown -R git log/
RUN chown -R git tmp/
RUN chmod -R u+rwX,go-w log/
RUN chmod -R u+rwX tmp/
RUN chmod -R u+rwX tmp/pids/
RUN chmod -R u+rwX tmp/sockets/
# Create the public/uploads/ directory
RUN mkdir public/uploads/
# Make sure only the GitLab user has access to the public/uploads/ directory
# now that files in public/uploads are served by gitlab-workhorse
RUN chmod 0700 public/uploads
# Change the permissions of the directory where CI job traces are stored
RUN chmod -R u+rwX builds/
# Change the permissions of the directory where CI artifacts are stored
RUN chmod -R u+rwX shared/artifacts/
# Change the permissions of the directory where GitLab Pages are stored
RUN chmod -R ug+rwX shared/pages/

# Copy the example Unicorn config
RUN cp config/unicorn.rb.example config/unicorn.rb

# Copy the example Rack attack config
RUN cp config/initializers/rack_attack.rb.example config/initializers/rack_attack.rb

# Configure Git global settings for git user
# 'autocrlf' is needed for the web editor
RUN git config --global core.autocrlf input

# Disable 'git gc --auto' because GitLab already runs 'git gc' when needed
RUN git config --global gc.auto 0

# Enable packfile bitmaps
RUN git config --global repack.writeBitmaps true

COPY GemfileLocal /home/git/gitlab
RUN bundle install --gemfile GemfileLocal

ENTRYPOINT ["/home/git/gitlab/entrypoint.sh"]
