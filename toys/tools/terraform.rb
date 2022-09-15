# frozen_string_literal: true

desc 'Access all Terraform commands'

remaining_args :args

def run
  exec_with_args 'terraform', args
end
