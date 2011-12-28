require 'yaml'
require 'pathname'
require 'mime/types'

begin
  require 'v8'
rescue LoadError
  STDERR.puts "WARNING: 'gem install therubyracer' for much faster CoffeeScript compilation."
end

require 'bunch/version'
require 'bunch/directory_node'
require 'bunch/file_node'
require 'bunch/coffee_node'
require 'bunch/sass_node'
require 'bunch/rack'

module Bunch
end

class << Bunch
  def generate(path)
    if File.exist?(path)
      Tree(path).contents
    elsif File.exist?(chopped_path = path.sub(%r(\.[^/]*?$), ''))
      Tree(chopped_path).contents
    else
      raise Errno::ENOENT, path
    end
  end

  def Tree(fn)
    case
    when File.directory?(fn)
      Bunch::DirectoryNode.new(fn)
    when fn =~ /\.coffee$/
      Bunch::CoffeeNode.new(fn)
    when fn =~ /\.s(a|c)ss$/
      Bunch::SassNode.new(fn)
    else
      Bunch::FileNode.new(fn)
    end
  end
end
