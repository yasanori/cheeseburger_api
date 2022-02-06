FROM ruby:2.7.2

ENV LANG C.UTF-8
ENV APP_ROOT /app

WORKDIR /app

RUN apt-get update \
  && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
  && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
  && apt-get update -qq \
  && apt-get install -y nodejs yarn \
  && apt-get install -y sqlite3 \
  && apt-get install -y libsqlite3-dev \
  && apt-get install -y vim \
  && apt-get clean  \
# Ruby-2.7以降だと`gem install bundler`しないとエラーが発生する
  && gem install bundler

RUN mkdir -p $APP_ROOT
WORKDIR $APP_ROOT

COPY Gemfile $APP_ROOT/Gemfile
COPY Gemfile.lock $APP_ROOT/Gemfile.lock
RUN bundle update --bundler \
&& bundle install  --jobs 4 --retry 3