module Bunch
  class EJSNode < FileNode
    def initialize(fn)
      EJSNode.require_ejs
      @filename = fn
    end

    def content
      @content ||= fetch(@filename) {
        <<-JAVASCRIPT
          (function() {
            this.JST || (this.JST = {});
            this.JST['#{template_name}'] = #{EJS.compile(File.read(@filename))};
          })();
        JAVASCRIPT
      }
    rescue => e
      raise CompileError.new(e, @filename)
    end

    def name
      File.basename(@filename, '.ejs')
    end

    def template_name
      name = @filename.sub(/\.jst\.ejs$/, '')

      if @options[:root]
        name.sub(/^#{Regexp.escape(@options[:root].to_s)}\//, '')
      else
        name
      end
    end

    def target_extension
      '.js'
    end
  end

  class << EJSNode
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
