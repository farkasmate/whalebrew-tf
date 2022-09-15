# frozen_string_literal: true

desc 'Manage external Terraform modules from GitHub'

include :exec, exit_on_nonzero_status: true

disable_argument_parsing

def run
  exec_with_args 'terrafile', args
end
