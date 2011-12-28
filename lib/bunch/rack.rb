module Bunch
  class Rack
    def initialize(path)
      @root = Pathname.new(path)
    end

    def call(env)
      path = @root.join(env['PATH_INFO'].sub(/^\//, '')).to_s
      [200, {'Content-Type' => 'text/plain'}, [Bunch.concatenate(path)]]
    rescue => e
      [500, {'Content-Type' => 'text/plain'}, [error_log(e)]]
    end

    private
      def error_log(e)
        "#{e.class}: #{e.message}\n  #{e.backtrace.join("\n  ")}"
      end
  end
end
