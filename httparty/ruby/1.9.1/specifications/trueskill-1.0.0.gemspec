# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "trueskill"
  s.version = "1.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Lars Kuhnt"]
  s.date = "2011-01-19"
  s.description = ""
  s.email = "lars@sauspiel.de"
  s.homepage = "http://github.com/saulabs/trueskill"
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.16"
  s.summary = "A ruby library for the trueskill rating system"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
