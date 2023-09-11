FROM ruby:3.1.0
RUN curl https://deb.nodesource.com/setup_12.x | bash
RUN curl https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client yarn
#ENV BUNDLER_VERSION=2.1.4
RUN gem install bundler
ENV RAILS_ENV development
RUN mkdir /myapp
WORKDIR /myapp
COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock
RUN npm install
RUN yarn install
RUN bundle install
COPY . /myapp
#RUN bundle exec rails webpacker:install
RUN bundle exec rake assets:precompile
EXPOSE 8000
