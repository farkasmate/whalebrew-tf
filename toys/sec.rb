# frozen_string_literal: true

desc 'Security scanner for your Terraform code'

include :exec, exit_on_nonzero_status: true

disable_argument_parsing

def run
  exec_with_args 'tfsec', args
end
