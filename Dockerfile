FROM ubuntu:latest

RUN apt-get update && apt-get install -y vim curl nodejs libmysqlclient-dev postgresql

RUN gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
RUN \curl -sSL https://get.rvm.io | bash -s stable --ruby

RUN echo "gem: --no-document" >> ~/.gemrc

RUN /bin/bash -c "source /etc/profile.d/rvm.sh && rvm gemset use global && gem install bundler && gem install nokogiri"

RUN /bin/bash -c "source /etc/profile.d/rvm.sh && rvm gemset create railsLatest && rvm use @railsLatest && gem install rails && rails -v"

RUN mkdir /railsApp
VOLUME /railsApp

WORKDIR /railsApp

CMD /bin/bash -c "source /etc/profile.d/rvm.sh && rvm use @railsLatest && bundle && rake db:migrate && rake assets:precompile && rm -rf tmp && rails s"

