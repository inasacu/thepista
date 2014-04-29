# -*- encoding: utf-8 -*-
# stub: omniauth-yahoo 0.0.5 ruby lib

Gem::Specification.new do |s|
  s.name = "omniauth-yahoo"
  s.version = "0.0.5"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Tim Breitkreutz"]
  s.date = "2014-04-21"
  s.description = "OmniAuth strategy for yahoo"
  s.email = ["tim@sbrew.com"]
  s.homepage = "https://github.com/timbreitkreutz/omniauth-yahoo"
  s.rubyforge_project = "omniauth-yahoo"
  s.rubygems_version = "2.2.2"
  s.summary = "OmniAuth strategy for yahoo"

  s.installed_by_version = "2.2.2" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<omniauth-oauth>, ["~> 1.0"])
    else
      s.add_dependency(%q<omniauth-oauth>, ["~> 1.0"])
    end
  else
    s.add_dependency(%q<omniauth-oauth>, ["~> 1.0"])
  end
end
