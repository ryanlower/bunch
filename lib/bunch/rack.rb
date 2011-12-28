module Bunch
  class Rack
    def initialize(path)
      @root = Pathname.new(path)
    end

    def call(env)
      path = @root.join(env['PATH_INFO'].sub(/^\//, '')).to_s
      type = MIME::Types.type_for(path).first || 'text/plain'

      [ 200, { 'Content-Type' => type.to_s    }, [ generate(path) ] ]
    rescue => e
      [ 500, { 'Content-Type' => 'text/plain' }, [ error_log(e)   ] ]
    end

    private
      def generate(path)
        if File.exist?(path)
          Bunch::Tree(path).contents
        elsif File.exist?(chopped_path = path.sub(%r(\.[^/]*?$), ''))
          Bunch::Tree(chopped_path).contents
        elsif File.basename(path).start_with?('all.')
          Bunch::Tree(File.dirname(path)).contents
        else
          raise Errno::ENOENT, path
        end
      end

      def error_log(e)
        "#{e.class}: #{e.message}\n  #{e.backtrace.join("\n  ")}"
      end
  end
end
