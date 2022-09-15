# BUILDER
ARG RUBY_VERSION
FROM ruby:${RUBY_VERSION}-alpine as BUILDER

WORKDIR /code

ADD Gemfile Gemfile.lock ./

RUN bundle config set --local without 'development' \
  && bundle install

# CLI
FROM ruby:${RUBY_VERSION}-alpine as CLI

COPY --from=BUILDER /usr/local/bundle /usr/local/bundle

RUN apk add --no-cache \
    bash \
    curl \
    git \
  && git clone --depth=1 https://github.com/tfutils/tfenv.git /opt/tfenv

ADD entrypoint.rb /entrypoint.rb
ADD toys/ /toys/

ENTRYPOINT ["/entrypoint.rb"]
