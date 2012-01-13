require 'fileutils'
require 'optparse'
require 'pathname'
require 'yaml'

require 'mime/types'

begin
  require 'v8'
rescue LoadError
  $stderr.puts "WARNING: 'gem install therubyracer' for much faster CoffeeScript compilation."
end

require 'bunch/version'
require 'bunch/rack'
require 'bunch/middleware'
require 'bunch/cache'

require 'bunch/abstract_node'
require 'bunch/directory_node'
require 'bunch/file_node'
require 'bunch/coffee_node'
require 'bunch/sass_node'

module Bunch
  class CompileError < StandardError
    def initialize(exception, filename)
      @exception = exception
      @filename = filename
    end

    def message
      "#{@filename}: #{@exception.message}"
    end
  end
end

class << Bunch
  def content_for(path)
    tree_for(normalized_path(path)).content
  end

  def tree_for(path)
    case
    when File.directory?(path)
      Bunch::DirectoryNode.new(path)
    when path =~ /\.coffee$/
      Bunch::CoffeeNode.new(path)
    when path =~ /\.s(a|c)ss$/
      Bunch::SassNode.new(path)
    else
      Bunch::FileNode.new(path)
    end
  end

  protected
    def normalized_path(path)
      case
      when File.exist?(path)
        path
      when File.exist?(chopped_path = path.sub(%r(\.[^.]*$), ''))
        chopped_path
      when File.basename(path).start_with?('all.') && File.exist?(dir_path = File.dirname(path))
        dir_path
      when (path_w_different_extension = Dir["#{chopped_path}.*"].first)
        path_w_different_extension
      else
        raise Errno::ENOENT, path.to_s
      end
    end
end
