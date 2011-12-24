module Bunch
  class Leaf
    def initialize(fn)
      @filename = fn
    end

    def contents
      File.read(@filename)
    end

    def inspect
      @filename.inspect
    end
  end
end
