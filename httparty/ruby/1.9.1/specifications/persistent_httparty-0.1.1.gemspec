# -*- encoding: utf-8 -*-
# stub: persistent_httparty 0.1.1 ruby lib

Gem::Specification.new do |s|
  s.name = "persistent_httparty"
  s.version = "0.1.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Matt Campbell"]
  s.date = "2013-01-16"
  s.description = "Persistent HTTP connections for HTTParty using the persistent_http gem. Keep the party alive!"
  s.email = ["persistent_httparty@soupmatt.com"]
  s.homepage = "https://github.com/soupmatt/persistent_httparty"
  s.require_paths = ["lib"]
  s.rubygems_version = "2.1.10"
  s.summary = "Persistent HTTP connections for HTTParty"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<httparty>, ["~> 0.9"])
      s.add_runtime_dependency(%q<persistent_http>, [">= 0"])
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<rspec>, ["~> 2.12"])
      s.add_development_dependency(%q<cucumber>, [">= 0"])
      s.add_development_dependency(%q<webmock>, [">= 0"])
    else
      s.add_dependency(%q<httparty>, ["~> 0.9"])
      s.add_dependency(%q<persistent_http>, [">= 0"])
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<rspec>, ["~> 2.12"])
      s.add_dependency(%q<cucumber>, [">= 0"])
      s.add_dependency(%q<webmock>, [">= 0"])
    end
  else
    s.add_dependency(%q<httparty>, ["~> 0.9"])
    s.add_dependency(%q<persistent_http>, [">= 0"])
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<rspec>, ["~> 2.12"])
    s.add_dependency(%q<cucumber>, [">= 0"])
    s.add_dependency(%q<webmock>, [">= 0"])
  end
end
