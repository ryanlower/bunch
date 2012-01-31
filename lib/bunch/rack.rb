module Bunch
  class Rack
    def initialize(path, opts={})
      @root = Pathname.new(path)
      @headers = {}

      if opts.delete(:no_cache)
        @headers['Cache-Control'] = 'private, max-age=0, must-revalidate'
        @headers['Pragma'] = 'no-cache'
        @headers['Expires'] = 'Thu, 01 Dec 1994 16:00:00 GMT'
      end

      Bunch.load_ignores(@root)
    end

    def call(env)
      path = @root.join(env['PATH_INFO'].sub(/^\//, '')).to_s
      type = MIME::Types.type_for(path).first || 'text/plain'

      [200, headers(type), [content_for(path)]]
    rescue => e
      [500, headers('text/plain'), [error_log(e)]]
    end

    private
      def content_for(path)
        Bunch.content_for(path)
      end

      def headers(mime_type)
        @headers.merge('Content-Type' => mime_type.to_s)
      end

      def error_log(e)
        "#{e.class}: #{e.message}\n  #{e.backtrace.join("\n  ")}"
      end
  end
end
