module Bunch
  class FileNode < AbstractNode
    attr_accessor :name, :target_extension

    def initialize(fn)
      @filename = fn

      if fn =~ /\.[^.]*$/
        @name = File.basename($`)
        @target_extension = $&
      else
        @name = File.basename(@filename)
        @target_extension = nil
      end
    end

    def content
      File.read(@filename)
    end

    def inspect
      @filename.inspect
    end
  end
end
