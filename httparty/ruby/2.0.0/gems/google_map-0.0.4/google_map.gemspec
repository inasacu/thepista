# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "google_map/version"

Gem::Specification.new do |s|
  s.name        = "google_map"
  s.version     = GoogleMap::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Jeff Dutil"]
  s.email       = ["JDutil@BurlingtonWebApps.com"]
  s.homepage    = "https://github.com/jdutil/google_map"
  s.summary     = %q{Extends geokit and gives convenient helpers for adding google maps to your application.}
  s.description = %q{Extends geokit and gives convenient helpers for adding google maps to your application.}

  s.rubyforge_project = "google_map"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
