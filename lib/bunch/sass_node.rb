module Bunch
  class SassNode
    include Caching

    def initialize(fn)
      unless defined?(@@sass_required)
        require 'sass'
        @@sass_required = true
      end
      @filename = fn
    rescue LoadError
      raise "'gem install sass' to compile .sass and .scss files."
    end

    def content
      @content ||= fetch(@filename) { Sass::Engine.for_file(@filename, {}).render }
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
