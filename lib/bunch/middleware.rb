# heavily inspired by Rack::URLMap

module Bunch
  class Middleware
    attr_accessor :app, :endpoint

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
      script_name = env['SCRIPT_NAME'].to_s

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

    protected
      def root_regexp
         Regexp.new("^#{Regexp.quote(@root_url).gsub('/', '/+')}(.*)")
      end
  end

  class << Middleware
    # Binds an instance of `Bunch::Middleware` in front of any instance
    # of the given middleware class. Whenever `klass` is instantiated,
    # any calls to `klass#call` will first pass through the single
    # instance of `Middleware` created by this method.
    #
    # You can compose any number of `Middleware` instances in front
    # of the same class.
    #
    # In practice, the purpose of this is to allow Bunch to take
    # precedence over `Rails::Rack::Static` in a Rails 2 context.
    # Since the server's instance of `Rails::Rack::Static` isn't part of
    # the `ActionController` stack, it isn't possible to use
    # Rails' normal middleware tools to insert Bunch in front of it,
    # which means any files in `public` would be served preferentially.
    #
    # @param [Class] klass Any Rack middleware class.
    # @param [Hash] options The options that would normally be passed to
    #   `Bunch::Middleware#initialize`.
    #
    # @example
    #   if Rails.env.development?
    #     Bunch::Middleware.insert_before Rails::Rack::Static,
    #       root_url: '/javascripts', path: 'app/scripts', no_cache: true
    #   end
    def insert_before(klass, options={})
      instance = new(nil, options)

      klass.class_eval do
        unbound_call = instance_method(:call)
        define_method(:call) do |env|
          instance.app = unbound_call.bind(self)
          instance.call(env)
        end
      end
    end
  end
end
