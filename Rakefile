require "bundler/gem_tasks"

begin
  require 'yard'
  YARD::Rake::YardocTask.new
rescue LoadError
end

require 'rake/testtask'

Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = false
end

task :default => :test
