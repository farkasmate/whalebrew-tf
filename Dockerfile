# BUILDER
ARG RUBY_VERSION
FROM ruby:${RUBY_VERSION}-alpine as BUILDER

WORKDIR /code

ADD Gemfile Gemfile.lock ./

RUN bundle config set --local without 'development' \
  && bundle install

# CLI
FROM ruby:${RUBY_VERSION}-alpine as CLI
ARG TERRAFORM_DOCS_VERSION

COPY --from=BUILDER /usr/local/bundle /usr/local/bundle

RUN apk add --no-cache \
    bash \
    curl \
    git \
  && git clone --depth=1 https://github.com/tfutils/tfenv.git /opt/tfenv \
  && mkdir -p /opt/terraform-docs/ \
  && curl https://github.com/terraform-docs/terraform-docs/releases/download/v${TERRAFORM_DOCS_VERSION}/terraform-docs-v${TERRAFORM_DOCS_VERSION}-Linux-amd64.tar.gz -sLo - \
    | tar xz -C /opt/terraform-docs/

ADD entrypoint.rb /entrypoint.rb
ADD toys/ /toys/

ENTRYPOINT ["/entrypoint.rb"]
