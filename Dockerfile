FROM ruby:3.3.8

RUN apt-get update && \
    apt-get install -y --force-yes python3 nodejs zlib1g && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN bundle config --global frozen 1

WORKDIR /usr/src/app

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8
ENV URL=http://developer.rebble.io
ENV HTTPS_URL=https://developer.rebble.io
ENV EXTERNAL_SERVER=https://example.com
ENV SKIP_DOCS=true
ENV JEKYLL_ENV=production

EXPOSE 4000

CMD ["bundle", "exec", "jekyll", "serve", "--host=0.0.0.0"]
