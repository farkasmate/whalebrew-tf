# frozen_string_literal: true

desc 'Shorthand for terraform plan'

remaining_args :args

def run
  exec_with_args 'terraform plan', args
end
