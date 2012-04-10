# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "acts_as_tree"
  s.version = "0.2.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Erik Dahlstrand", "Rails Core", "Mark Turner", "Swanand Pagnis"]
  s.date = "2012-04-09"
  s.description = "Specify this acts_as extension if you want to model a tree structure by providing a parent association and a children association."
  s.email = ["erik.dahlstrand@gmail.com", "mark@amerine.net", "swanand.pagnis@gmail.com"]
  s.homepage = "https://github.com/amerine/acts_as_tree"
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubyforge_project = "acts_as_tree"
  s.rubygems_version = "1.8.16"
  s.summary = "Provides a simple tree behaviour to active_record mdoels."

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<bundler>, [">= 1.0.0"])
      s.add_development_dependency(%q<activerecord>, [">= 1.15.4.7794"])
      s.add_development_dependency(%q<rdoc>, [">= 0"])
      s.add_development_dependency(%q<sqlite3>, [">= 0"])
    else
      s.add_dependency(%q<bundler>, [">= 1.0.0"])
      s.add_dependency(%q<activerecord>, [">= 1.15.4.7794"])
      s.add_dependency(%q<rdoc>, [">= 0"])
      s.add_dependency(%q<sqlite3>, [">= 0"])
    end
  else
    s.add_dependency(%q<bundler>, [">= 1.0.0"])
    s.add_dependency(%q<activerecord>, [">= 1.15.4.7794"])
    s.add_dependency(%q<rdoc>, [">= 0"])
    s.add_dependency(%q<sqlite3>, [">= 0"])
  end
end
