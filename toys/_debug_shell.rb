# frozen_string_literal: true

desc 'Run debug shell'

include :exec, exit_on_nonzero_status: true

def run
  exec_with_args 'sh'
end
