module Bunch
  class SassNode < FileNode
    def initialize(fn)
      unless defined?(@@sass_required)
        require 'sass'
        @@sass_required = true
      end

      unless defined?(@@sass_style)
        @@sass_style = ENV['SASS_STYLE'] || 'nested'
      end

      @filename = fn
    rescue LoadError
      raise "'gem install sass' to compile .sass and .scss files."
    end

    def content
      @content ||= fetch(@filename) { Sass::Engine.for_file(@filename, :style => @@sass_style.to_sym).render }
    end

    def name
      File.basename(@filename).sub(/\.s(c|a)ss$/, '')
    end

    def target_extension
      '.css'
    end
  end
end
