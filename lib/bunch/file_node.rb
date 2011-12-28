module Bunch
  class FileNode
    def initialize(fn)
      @filename = fn
    end

    def contents
      File.read(@filename)
    end

    def name
      File.basename(@filename).sub(%r(\.[^/]*?$), '')
    end

    def inspect
      @filename.inspect
    end
  end
end
