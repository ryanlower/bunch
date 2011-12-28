module Bunch
  class FileNode
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
