module Bunch
  class CoffeeNode < FileNode
    def initialize(fn)
      unless defined?(@@coffee_required)
        require 'coffee-script'
        @@coffee_required = true
      end
      @filename = fn
    rescue LoadError
      raise "'gem install coffee-script' to compile .coffee files."
    end

    def content
      @content ||= fetch(@filename) { CoffeeScript.compile(File.read(@filename), :bare => false) }
    end

    def name
      File.basename(@filename, '.coffee')
    end

    def target_extension
      '.js'
    end
  end
end
