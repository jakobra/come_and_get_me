FROM debian:jessie

RUN set -ex \
   && apt-get update && apt-get install -y \
 build-essential libssl-dev curl ruby-mysql \
 libmysqlclient-dev libssl-dev git-core \
 imagemagick libmagickwand-dev \
 && rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/sstephenson/rbenv.git /root/.rbenv \
 && git clone https://github.com/sstephenson/ruby-build.git /root/.rbenv/plugins/ruby-build \
 && /root/.rbenv/plugins/ruby-build/install.sh

ENV PATH /root/.rbenv/bin:$PATH

ENV CONFIGURE_OPTS --disable-install-doc
RUN rbenv install 1.8.7-p371 && rbenv rehash

RUN mkdir -p /app
WORKDIR /app

COPY .ruby-version ./
RUN rbenv exec ruby -v && rbenv exec gem install bundler

COPY Gemfile Gemfile.lock ./
RUN rbenv exec bundle install

COPY . ./

EXPOSE 3000
CMD ["rbenv", "exec", "ruby", "script/server" ]
