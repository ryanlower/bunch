module Bunch
  class CoffeeNode < FileNode
    def initialize(fn)
      CoffeeNode.require_coffee
      @filename = fn
    end

    def content
      @content ||= fetch(@filename) { CoffeeScript.compile(File.read(@filename), :bare => CoffeeNode.bare) }
    rescue => e
      raise CompileError.new(e, @filename)
    end

    def name
      File.basename(@filename, '.coffee')
    end

    def target_extension
      '.js'
    end
  end

  class << CoffeeNode
    attr_writer :bare

    def require_coffee
      unless @required
        require 'coffee-script'
        @required = true
      end
    rescue LoadError
      raise "'gem install coffee-script' to compile .coffee files."
    end

    def bare
      defined?(@bare) ? @bare : (@bare = false)
    end
  end
end
