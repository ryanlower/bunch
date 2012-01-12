require 'test_helper'

class RackTest < Test::Unit::TestCase
  context 'given a tree of js and coffee files' do
    setup do
      @app = Bunch::Rack.new('example/js')
    end

    context 'when / is requested' do
      setup do
        perform_request
      end

      should 'combine everything' do
        assert_equal "1 2 3 4 5 6 7 8 9 10", squeeze(@body)
      end

      should 'have text/plain content type' do
        assert_equal 'text/plain', @headers['Content-Type']
      end
    end

    context 'when /all.js is requested' do
      setup do
        perform_request('/.js')
      end

      should 'combine everything in the correct order' do
        assert_equal "1 2 3 4 5 6 7 8 9 10", squeeze(@body)
      end

      should 'have application/javascript content type' do
        assert_equal "application/javascript", @headers['Content-Type']
      end
    end

    context 'with a subfolder of js files' do
      setup do
        perform_request('/test2.js')
      end

      should 'combine everything in that folder and nothing else' do
        assert_equal "2 3 4", squeeze(@body)
        assert %w(1 5 6 7 8 9 10).all? { |n| !@body.include?(n) }
      end
    end

    context 'with a subfolder containing another folder' do
      context 'when the outer folder is requested' do
        setup do
          perform_request('/test3.js')
        end

        should 'combine the contents of both folders in the correct order' do
          assert_equal "5 6 7", squeeze(@body)
        end
      end

      context 'when the inner folder is requested' do
        setup do
          perform_request('/test3/test3b.js')
        end

        should 'only render the inner folder' do
          assert_equal "6 7", squeeze(@body)
        end
      end
    end
  end

  context 'given a tree of scss files' do
    setup do
      @app = Bunch::Rack.new('example/css')
      perform_request('/all.css')
    end

    should 'work' do
      assert_equal "body { a: 1 } body { b: 2 } body { c: 3 }", squeeze(@body)
      assert_equal "text/css", @headers['Content-Type']
    end
  end
end
