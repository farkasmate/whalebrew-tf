# frozen_string_literal: true

desc 'Generate documentation from Terraform modules'

include :exec, exit_on_nonzero_status: true

disable_argument_parsing

def run
  exec_with_args 'terraform-docs', args
end
