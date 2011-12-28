$:.unshift File.expand_path('../../lib', __FILE__)
require 'bunch'

run Rack::URLMap.new \
  "/stylesheets" => Bunch::Rack.new('example/css'),
  "/javascripts" => Bunch::Rack.new('example/js')
