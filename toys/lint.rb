# frozen_string_literal: true

desc 'A Pluggable Terraform Linter'

include :exec, exit_on_nonzero_status: true

disable_argument_parsing

def run
  exec_with_args 'tflint', args
end
