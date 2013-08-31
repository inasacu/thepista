# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "hirefire-resource"
  s.version = "0.1.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Michael van Rooijen"]
  s.date = "2013-06-19"
  s.description = "HireFire - The Heroku Dyno Manager"
  s.email = "michael@hirefire.io"
  s.executables = ["hirefire", "hirefireapp"]
  s.files = ["bin/hirefire", "bin/hirefireapp"]
  s.homepage = "http://hirefire.io/"
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.16"
  s.summary = "HireFire - The Heroku Dyno Manager"

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
