# frozen_string_literal: true

desc 'Proxy Terraform commands'

include :exec, exit_on_nonzero_status: false

disable_argument_parsing

def run
  exec_with_args 'terraform', args

  return unless (args - ['-h', '-help', '--help', 'help']).empty?

  puts <<~MISC

    Misc commands:
        tfenv              Terraform version manager
  MISC
end