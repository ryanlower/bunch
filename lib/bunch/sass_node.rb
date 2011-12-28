module Bunch
  class SassNode
    def initialize(fn)
      require 'sass'
      @filename = fn
    end

    def contents
      Sass::Engine.for_file(@filename, {}).render
    end

    def name
      File.basename(@filename).sub(/\.s(c|a)ss$/, '')
    end

    def inspect
      @filename.inspect
    end
  end
end
