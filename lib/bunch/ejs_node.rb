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
}).call(this);
        JAVASCRIPT
      }
    rescue => e
      raise CompileError.new(e, @filename)
    end

    def name
      File.basename(@filename, '.ejs')
    end

    def template_name
      @filename.gsub('app/scripts/','').gsub('.jst.ejs','').gsub('/templates', '')
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
