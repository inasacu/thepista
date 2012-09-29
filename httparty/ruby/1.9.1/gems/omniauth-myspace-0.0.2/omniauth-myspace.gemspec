# -*- encoding: utf-8 -*-
require File.expand_path('../lib/omniauth/myspace/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["John Ferlito"]
  gem.email         = ["johnf@inodes.org"]
  gem.description   = %q{MySpace strategy for omniauth}
  gem.summary       = %q{MySpace strategy for omniauth}
  gem.homepage      = 'https://github.com/johnf/omniauth-myspace'

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "omniauth-myspace"
  gem.require_paths = ["lib"]
  gem.version       = OmniAuth::Myspace::VERSION

  gem.add_runtime_dependency 'omniauth-oauth'
  gem.add_runtime_dependency 'multi_json'

  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'rake'
end
