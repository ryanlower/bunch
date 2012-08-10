module Bunch
  class ECONode < FileNode
    def initialize(fn)
      ECONode.require_eco
      @filename = fn
    end

    def content
      @content ||= fetch(@filename) {
        <<-JAVASCRIPT
          (function() {
            this.JST || (this.JST = {});
            this.JST['#{template_name}'] = #{Eco.compile(File.read(@filename))};
          })();
        JAVASCRIPT
      }
    rescue => e
      raise CompileError.new(e, @filename)
    end

    def name
      File.basename(@filename, '.eco')
    end

    def template_name
      name = @filename.sub(/\.jst\.eco$/, '')

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

  class << ECONode
    def require_eco
      unless @required
        require 'eco'
        @required = true
      end
    rescue LoadError
      raise "'gem install eco' to compile .eco files."
    end
  end
end
