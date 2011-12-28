module Bunch
  class CoffeeNode
    def initialize(fn)
      require 'coffee-script'
      @filename = fn
    rescue LoadError
      raise "'gem install coffee-script' to compile .coffee files."
    end

    def contents
      @contents ||= CoffeeScript.compile(File.read(@filename), :bare => false)
    end

    def name
      File.basename(@filename, '.coffee')
    end

    def target_extension
      'js'
    end

    def inspect
      @filename.inspect
    end
  end
end
