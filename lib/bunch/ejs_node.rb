module Bunch
  class EJSNode < FileNode
    def initialize(fn)
      EJSNode.require_ejs
      @filename = fn
    end

    def content
      @content ||= fetch(@filename) { EJS.compile(File.read(@filename)) }
    rescue => e
      raise CompileError.new(e, @filename)
    end

    def name
      File.basename(@filename, '.ejs')
    end

    def target_extension
      '.jst'
    end
  end

  class << EJSNode
    attr_writer :bare

    def require_ejs
      unless @required
        require 'ejs'
        @required = true
      end
    rescue LoadError
      raise "'gem install ejs' to compile .ejs files."
    end
  end
end
