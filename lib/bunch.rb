require 'bunch/version'
require 'bunch/leaf'
require 'bunch/node'
require 'yaml'

module Bunch
  WARNINGS = true

  class << self
    attr_accessor :extension

    def concatenate(path)
      tree_for(path).contents
    end

    def tree_for(path)
      if File.directory?(path)
        Node.new(path)
      else
        Leaf.new(path)
      end
    end
  end
end
