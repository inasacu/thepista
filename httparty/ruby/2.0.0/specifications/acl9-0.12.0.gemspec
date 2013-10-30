# -*- encoding: utf-8 -*-
# stub: acl9 0.12.0 ruby lib

Gem::Specification.new do |s|
  s.name = "acl9"
  s.version = "0.12.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["oleg dashevskii"]
  s.date = "2010-01-03"
  s.description = "Role-based authorization system for Rails with a nice DSL for access control lists"
  s.email = "olegdashevskii@gmail.com"
  s.extra_rdoc_files = ["README.textile", "TODO"]
  s.files = ["README.textile", "TODO"]
  s.homepage = "http://github.com/be9/acl9"
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = "2.1.10"
  s.summary = "Yet another role-based authorization system for Rails"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<jeremymcanally-context>, [">= 0.5.5"])
      s.add_development_dependency(%q<jnunemaker-matchy>, [">= 0.4.0"])
    else
      s.add_dependency(%q<jeremymcanally-context>, [">= 0.5.5"])
      s.add_dependency(%q<jnunemaker-matchy>, [">= 0.4.0"])
    end
  else
    s.add_dependency(%q<jeremymcanally-context>, [">= 0.5.5"])
    s.add_dependency(%q<jnunemaker-matchy>, [">= 0.4.0"])
  end
end
