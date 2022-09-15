# frozen_string_literal: true

desc 'Terraform version manager'

include :exec, exit_on_nonzero_status: true

disable_argument_parsing

def run
  exec_with_args 'tfenv', args
end
