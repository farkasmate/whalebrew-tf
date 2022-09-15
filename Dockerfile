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
ARG TERRAGRUNT_VERSION
ARG TFENV_VERSION
ARG TFLINT_VERSION
ARG TFSEC_VERSION

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
  && ln -s /opt/terrafile/terrafile /usr/local/bin/terrafile \
  # terraform-compliance
  && pip install --no-cache-dir --root-user-action=ignore terraform-compliance==${TERRAFORM_COMPLIANCE_VERSION} \
  # terraform-docs
  && mkdir -p /opt/terraform-docs/ \
  && curl https://github.com/terraform-docs/terraform-docs/releases/download/v${TERRAFORM_DOCS_VERSION}/terraform-docs-v${TERRAFORM_DOCS_VERSION}-Linux-amd64.tar.gz -sLo - \
    | tar xz -C /opt/terraform-docs/ \
  && ln -s /opt/terraform-docs/terraform-docs /usr/local/bin/terraform-docs \
  # terragrunt
  && mkdir -p /opt/terragrunt/ \
  && curl https://github.com/gruntwork-io/terragrunt/releases/download/v${TERRAGRUNT_VERSION}/terragrunt_linux_amd64 -sLo /opt/terragrunt/terragrunt \
  && curl https://raw.githubusercontent.com/gruntwork-io/terragrunt/v${TERRAGRUNT_VERSION}/LICENSE.txt -sLo /opt/terragrunt/LICENSE.txt \
  && chmod a+x /opt/terragrunt/terragrunt \
  && ln -s /opt/terragrunt/terragrunt /usr/local/bin/terragrunt \
  # tfenv
  && git clone --quiet --config advice.detachedHead=false --depth=1 --branch "v${TFENV_VERSION}" https://github.com/tfutils/tfenv.git /opt/tfenv \
  && ln -s /opt/tfenv/bin/terraform /usr/local/bin/terraform \
  && ln -s /opt/tfenv/bin/tfenv /usr/local/bin/tfenv \
  # tflint
  && mkdir -p /opt/tflint \
  && curl https://github.com/terraform-linters/tflint/releases/download/v${TFLINT_VERSION}/tflint_linux_amd64.zip -sLo /tmp/tflint_linux_amd64.zip \
  && unzip /tmp/tflint_linux_amd64.zip -d /opt/tflint \
  && rm /tmp/tflint_linux_amd64.zip \
  && curl https://raw.githubusercontent.com/terraform-linters/tflint/v${TFLINT_VERSION}/LICENSE -sLo /opt/tflint/LICENSE \
  && ln -s /opt/tflint/tflint /usr/local/bin/tflint \
  # tfsec
  && mkdir -p /opt/tfsec \
  && curl https://github.com/aquasecurity/tfsec/releases/download/v${TFSEC_VERSION}/tfsec-linux-amd64 -sLo /opt/tfsec/tfsec \
  && chmod a+x /opt/tfsec/tfsec \
  && curl  https://raw.githubusercontent.com/aquasecurity/tfsec/v${TFSEC_VERSION}/LICENSE -sLo /opt/tfsec/LICENSE \
  && ln -s /opt/tfsec/tfsec /usr/local/bin/tfsec

ADD entrypoint.rb /entrypoint.rb
ADD toys/ /toys/

ENTRYPOINT ["/entrypoint.rb"]
