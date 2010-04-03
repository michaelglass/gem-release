require 'rubygems/command_manager'
require 'rubygems/commands/build_command'
require 'rubygems/commands/push_command'

class Gem::Commands::ReleaseCommand < Gem::Command
  def initialize
    super 'release', 'Build a gem from a gemspec and push to rubygems.org'
  end

  def arguments # :nodoc:
    "GEMSPEC_FILE optional (will use the first *.gemspec if not specified)"
  end

  def usage # :nodoc:
    "#{program_name} [GEMSPEC_FILE]"
  end
  
  def execute
    file_name = build
    push(file_name)
  end
  
  def build
    command = Gem::Commands::BuildCommand.new
    command.handle_options([gemspec])
    command.execute
    command.load_gemspecs(gemspec).first.file_name
  end
  
  def push(filename)
    command = Gem::Commands::PushCommand.new
    command.handle_options([filename])
    command.execute
  end
  
  def gemspec
    @gemspec ||= begin
      gemspec = Array(options[:args]).first
      gemspec ||= Dir['*.gemspec'].first
      gemspec || raise("No gemspec found or given.")
    end
  end
end

Gem::CommandManager.instance.register_command :release