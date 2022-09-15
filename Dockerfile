# BUILDER
ARG RUBY_VERSION
FROM ruby:${RUBY_VERSION}-alpine as BUILDER

WORKDIR /code

ADD Gemfile Gemfile.lock ./

RUN bundle config set --local without 'development' \
  && bundle install

# CLI
FROM ruby:${RUBY_VERSION}-alpine as CLI

ARG TERRAFILE_VERSION
ARG TERRAFORM_COMPLIANCE_VERSION
ARG TERRAFORM_DOCS_VERSION
ARG TFENV_VERSION

COPY --from=BUILDER /usr/local/bundle /usr/local/bundle

RUN apk add --no-cache \
    bash \
    curl \
    git \
    py3-pip \
    python3 \
  # terrafile
  && mkdir -p /opt/terrafile/ \
  && curl https://github.com/coretech/terrafile/releases/download/v${TERRAFILE_VERSION}/terrafile_${TERRAFILE_VERSION}_Linux_x86_64.tar.gz -sLo - \
    | tar xz -C /opt/terrafile/ \
  # terraform-compliance
  && pip install --no-cache-dir --root-user-action=ignore terraform-compliance==${TERRAFORM_COMPLIANCE_VERSION} \
  # terraform-docs
  && mkdir -p /opt/terraform-docs/ \
  && curl https://github.com/terraform-docs/terraform-docs/releases/download/v${TERRAFORM_DOCS_VERSION}/terraform-docs-v${TERRAFORM_DOCS_VERSION}-Linux-amd64.tar.gz -sLo - \
    | tar xz -C /opt/terraform-docs/ \
  # tfenv
  && git clone --quiet --config advice.detachedHead=false --depth=1 --branch "v${TFENV_VERSION}" https://github.com/tfutils/tfenv.git /opt/tfenv

ADD entrypoint.rb /entrypoint.rb
ADD toys/ /toys/

ENTRYPOINT ["/entrypoint.rb"]
