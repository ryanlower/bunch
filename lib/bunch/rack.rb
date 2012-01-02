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
        case
        when File.exist?(path)
          contents(path)
        when File.exist?(chopped_path = path.sub(%r(\.[^.]*$), ''))
          contents(chopped_path)
        when File.basename(path).start_with?('all.')
          contents(File.dirname(path))
        when (path_w_different_extension = Dir["#{chopped_path}.*"].first)
          contents(path_w_different_extension)
        else
          raise Errno::ENOENT, path.to_s
        end
      end

      def contents(path)
        Bunch::Tree(path.to_s).contents
      end

      def error_log(e)
        "#{e.class}: #{e.message}\n  #{e.backtrace.join("\n  ")}"
      end
  end
end
