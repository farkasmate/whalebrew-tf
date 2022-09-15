# frozen_string_literal: true

desc 'Terraform version manager'

remaining_args :args

def run
  exec_with_args 'tfenv', args
end
