FROM ubuntu:latest
# system dependencies
RUN apt-get update && apt-get install -y vim curl wget nodejs libmysqlclient-dev postgresql git

# grab gosu for easy step-down from root
ENV GOSU_VERSION 1.7
RUN set -x \
	&& wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture)" \
	&& wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture).asc" \
	&& export GNUPGHOME="$(mktemp -d)" \
	&& gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
	&& gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu \
	&& rm -r "$GNUPGHOME" /usr/local/bin/gosu.asc \
	&& chmod +x /usr/local/bin/gosu \
	&& gosu nobody true

# create rails user
RUN useradd -m rails

# install rvm and ruby for the rails user. Needs root for ruby autolibs.
USER rails
RUN gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
RUN \curl -sSL https://get.rvm.io | bash -s stable
USER root
RUN /bin/bash -c "source /home/rails/.rvm/scripts/rvm && rvm install ruby --latest"
RUN chown -R rails:rails /home/rails

# install rails
USER rails
RUN echo "gem: --no-document" >> ~/.gemrc
RUN /bin/bash -c "source /home/rails/.rvm/scripts/rvm && rvm gemset use global && gem install bundler && gem install nokogiri"
RUN /bin/bash -c "source /home/rails/.rvm/scripts/rvm && rvm gemset create railsLatest && rvm use @railsLatest && gem install rails && rails -v"

# create volume directory
USER root
RUN mkdir /railsApp && chown rails:rails /railsApp
VOLUME /railsApp
WORKDIR /railsApp

# entrypoint
COPY docker-entrypoint.sh /usr/local/bin
ENTRYPOINT ["docker-entrypoint.sh"]

