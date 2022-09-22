# frozen_string_literal: true

desc 'Proxy Terraform commands'

include :exec, exit_on_nonzero_status: false

disable_argument_parsing

def run # rubocop:disable Metrics/AbcSize
  exec_with_args 'terraform', args

  return unless (args - ['-h', '-help', '--help', 'help']).empty?

  puts "\nMisc commands:"

  tools = cli.loader.list_subtools(tool_name).collect do |tool|
    { tool.full_name.join(' ') => tool.desc.to_s }
  end.reduce({}, &:merge)

  max_length = [12, *tools.keys.map(&:size)].max

  tools.sort.to_h.each do |name, description|
    pad = ' ' * (max_length - name.length)
    puts "  #{name}#{pad}  #{description}"
  end
end
