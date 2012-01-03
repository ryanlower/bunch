# heavily inspired by Rack::URLMap

module Bunch
  class Middleware
    attr_accessor :app

    def initialize(app, options={})
      unless options[:root_url] && options[:path]
        raise "Must provide :root_url and :path"
      end

      @app = app
      @root_url = options.delete(:root_url)
      @endpoint = Bunch::Rack.new(options.delete(:path), options)
    end

    def call(env)
      path = env['PATH_INFO'].to_s
      script_name = env['SCRIPT_NAME']

      if path =~ root_regexp &&
          (rest = $1) &&
          (rest.empty? || rest[0] == ?/)

        @endpoint.call(
          env.merge(
            'SCRIPT_NAME' => (script_name + @root_url),
            'PATH_INFO'   => rest
          )
        )
      else
        @app.call(env)
      end
    end

    private
      def root_regexp
         Regexp.new("^#{Regexp.quote(@root_url).gsub('/', '/+')}(.*)")
      end
  end
end
