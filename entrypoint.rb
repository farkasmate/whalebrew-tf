#!/usr/bin/env ruby
# frozen_string_literal: true

require 'colorize'
require 'toys-core'
require 'toys/utils/exec'

def exec_with_args(cmd, args = [])
  final_cmd = "#{cmd} #{args.join(' ')}"

  warn "Running: #{final_cmd}".yellow if ENV['TF_VERBOSE']
  exec final_cmd
end

cli = Toys::CLI.new(executable_name: 'tf')

toys_dir = if File.exist? '/.dockerenv'
             '/toys'
           else
             'toys'
           end

cli.add_config_path File.join(toys_dir, '_terraform.rb')
cli.add_config_path toys_dir

exit(cli.run(*ARGV))
