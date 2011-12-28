module Bunch
  class SassNode
    def initialize(fn)
      require 'sass'
      @filename = fn
    rescue LoadError
      $stderr.puts "ERROR: 'gem install sass' to compile .sass and .scss files."
      exit 1
    end

    def contents
      @contents ||= Sass::Engine.for_file(@filename, {}).render
    end

    def name
      File.basename(@filename).sub(/\.s(c|a)ss$/, '')
    end

    def target_extension
      'css'
    end

    def inspect
      @filename.inspect
    end
  end
end
