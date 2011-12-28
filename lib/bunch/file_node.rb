module Bunch
  class FileNode
    attr_reader :name, :target_extension

    def initialize(fn)
      @filename = fn

      if fn =~ %r(\.([^/]*?)$)
        @name = File.basename($`)
        @target_extension = $1
      else
        @name = File.basename(@filename)
      end
    end

    def contents
      File.read(@filename)
    end

    def inspect
      @filename.inspect
    end
  end
end
