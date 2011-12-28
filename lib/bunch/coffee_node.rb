module Bunch
  class CoffeeNode
    def initialize(fn)
      require 'coffee-script'
      @filename = fn
    end

    def contents
      CoffeeScript.compile(File.read(@filename), :bare => false)
    end

    def inspect
      @filename.inspect
    end
  end
end
