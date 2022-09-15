# frozen_string_literal: true

desc 'Shorthand for terraform init'

remaining_args :args

def run
  exec_with_args 'terraform init', args
end
