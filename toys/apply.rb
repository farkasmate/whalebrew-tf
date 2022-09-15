# frozen_string_literal: true

desc 'Shorthand for terraform apply'

remaining_args :args

def run
  exec_with_args 'terraform apply', args
end
