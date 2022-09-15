# frozen_string_literal: true

desc 'A thin wrapper for Terraform that provides extra tools for working with multiple Terraform modules'

include :exec, exit_on_nonzero_status: true

disable_argument_parsing

def run
  exec_with_args 'terragrunt', args
end
