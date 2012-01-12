$:.unshift File.expand_path('../../lib', __FILE__)

require 'bunch'
require 'test/unit'
require 'shoulda-context'

# collapse whitespace and remove semicolons
def squeeze(js)
  js.gsub(/;/, '').gsub(/\n/, ' ').strip.squeeze
end

# perform a request for the given path and set @status, @headers, and @body.
def perform_request(path='/')
  env = {
    'REQUEST_METHOD' => 'GET',
    'PATH_INFO' => path
  }
  out = @app.call(env)
  @status, @headers, @body = out[0], out[1], out[2].join
end
