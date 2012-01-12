require 'test_helper'

class MiddlewareTest < Test::Unit::TestCase
  context 'using the Middleware class' do
    setup do
      @app = Bunch::Middleware.new(nil,
        :root_url => '/javascripts',
        :path => '/example/js'
      )
      @mock = mock
      @mock.expects(:call).returns([200, {}, ['hello']])
    end

    should 'ignore requests without the correct url' do
      @app.app = @mock
      perform_request('/not_javascripts/hello.html')
      assert_equal @body, 'hello'
    end

    should 'pass on requests with the correct url' do
      @app.endpoint = @mock
      perform_request('/javascripts/hello.js')
      assert_equal @body, 'hello'
    end
  end
end