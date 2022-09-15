#!/usr/bin/env ruby
# frozen_string_literal: true

require 'colorize'
require 'toys-core'
require 'toys/utils/exec'

def exec_with_args(cmd, args)
  args.delete_at(args.index('--') || args.length)
  final_cmd = "#{cmd} #{args.join(' ')}"

  warn "Running: #{final_cmd}".yellow if ENV['TF_VERBOSE']
  exec final_cmd
end

cli = Toys::CLI.new(
  executable_name: 'tf',
  middleware_stack: [
    Toys::Middleware.spec(
      :handle_usage_errors
    ),
    Toys::Middleware.spec(
      :show_help,
      help_flags: ['-h', '--help'],
      default_recursive: true,
      fallback_execution: true,
      stream: $stderr
    )
  ]
)

toys_dir = if File.exist? '/.dockerenv'
             '/toys'
           else
             'toys'
           end

cli.add_config_path toys_dir

exit(cli.run(*ARGV))
