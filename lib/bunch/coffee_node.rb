module Bunch
  class CoffeeNode
    def initialize(fn)
      require 'coffee-script'
      @filename = fn
    end

    def contents
      CoffeeScript.compile(File.read(@filename), :bare => false)
    end

    def name
      File.basename(@filename, '.coffee')
    end

    def inspect
      @filename.inspect
    end
  end
end
