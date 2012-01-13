module Bunch
  class SassNode < FileNode
    def initialize(fn)
      SassNode.require_sass
      @filename = fn
    end

    def content
      @content ||= fetch(@filename) { Sass::Engine.for_file(@filename, :style => SassNode.style).render }
    rescue => e
      e.message = "processing #{@filename}: #{e.message}"
      raise e
    end

    def name
      File.basename(@filename).sub(/\.s(c|a)ss$/, '')
    end

    def target_extension
      '.css'
    end
  end

  class << SassNode
    attr_writer :style

    def require_sass
      unless @required
        require 'sass'
        @required = true
      end
    rescue LoadError
      raise "'gem install sass' to compile .sass and .scss files."
    end

    def style
      @style ||= (env = ENV['SASS_STYLE']) ? env.to_sym : :nested
    end
  end
end
