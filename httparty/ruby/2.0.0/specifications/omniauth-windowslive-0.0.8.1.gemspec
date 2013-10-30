# -*- encoding: utf-8 -*-
# stub: omniauth-windowslive 0.0.8.1 ruby lib

Gem::Specification.new do |s|
  s.name = "omniauth-windowslive"
  s.version = "0.0.8.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Joel AZEMAR"]
  s.date = "2012-03-07"
  s.email = ["joel.azemar@gmail.com"]
  s.homepage = "https://github.com/joel/omniauth-windowslive"
  s.require_paths = ["lib"]
  s.rubyforge_project = "omniauth-windowslive"
  s.rubygems_version = "2.1.10"
  s.summary = "Windows Live, Hotmail, SkyDrive, Windows Live Messenger, and other services... strategy for OmniAuth"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<omniauth-oauth2>, ["~> 1.0"])
      s.add_runtime_dependency(%q<multi_json>, [">= 1.0.3"])
      s.add_development_dependency(%q<rspec>, ["~> 2.7"])
      s.add_development_dependency(%q<rack-test>, [">= 0"])
      s.add_development_dependency(%q<webmock>, [">= 0"])
    else
      s.add_dependency(%q<omniauth-oauth2>, ["~> 1.0"])
      s.add_dependency(%q<multi_json>, [">= 1.0.3"])
      s.add_dependency(%q<rspec>, ["~> 2.7"])
      s.add_dependency(%q<rack-test>, [">= 0"])
      s.add_dependency(%q<webmock>, [">= 0"])
    end
  else
    s.add_dependency(%q<omniauth-oauth2>, ["~> 1.0"])
    s.add_dependency(%q<multi_json>, [">= 1.0.3"])
    s.add_dependency(%q<rspec>, ["~> 2.7"])
    s.add_dependency(%q<rack-test>, [">= 0"])
    s.add_dependency(%q<webmock>, [">= 0"])
  end
end
