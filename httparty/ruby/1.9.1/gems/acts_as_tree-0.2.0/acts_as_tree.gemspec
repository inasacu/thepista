# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "acts_as_tree/version"

Gem::Specification.new do |s|
  s.name        = "acts_as_tree"
  s.version     = ActiveRecord::Acts::Tree::VERSION
  s.authors     = ["Erik Dahlstrand", "Rails Core", "Mark Turner", "Swanand Pagnis"]
  s.email       = ["erik.dahlstrand@gmail.com", "mark@amerine.net", "swanand.pagnis@gmail.com"]
  s.homepage    = "https://github.com/amerine/acts_as_tree"
  s.summary     = %q{Provides a simple tree behaviour to active_record mdoels.}
  s.description = %q{Specify this acts_as extension if you want to model a tree structure by providing a parent association and a children association.}

  s.rubyforge_project = "acts_as_tree"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  s.rdoc_options  = ["--charset=UTF-8"]

  # Dependencies (installed via 'bundle install')...
  s.add_development_dependency("bundler", [">= 1.0.0"])
  s.add_development_dependency("activerecord", [">= 1.15.4.7794"])
  s.add_development_dependency("rdoc")
  s.add_development_dependency("sqlite3")
end
