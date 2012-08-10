# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'bunch/version'

Gem::Specification.new do |s|
  s.name        = 'bunch'
  s.version     = Bunch::VERSION
  s.authors     = ['Ryan Fitzgerald']
  s.email       = ['rfitz@academia.edu']
  s.homepage    = ''
  s.summary     = %q{Directory-structure-based asset bundling.}
  s.description = %q{Directory-structure-based asset bundling.}

  s.rubyforge_project = 'bunch'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ['lib']

  s.add_runtime_dependency 'mime-types'

  s.add_development_dependency 'yard'
  s.add_development_dependency 'rdiscount'
  s.add_development_dependency 'shoulda-context'
  s.add_development_dependency 'mocha'

  s.add_development_dependency 'coffee-script'
  s.add_development_dependency 'sass'
  s.add_development_dependency 'ejs'
  s.add_development_dependency 'eco'
end
