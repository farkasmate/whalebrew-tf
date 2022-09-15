# frozen_string_literal: true

desc 'Lightweight, security focused, BDD test framework against Terraform'

include :exec, exit_on_nonzero_status: true

disable_argument_parsing

def run
  exec_with_args 'terraform-compliance', args
end
