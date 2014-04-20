# -*- encoding: utf-8 -*-
# stub: geokit 1.8.4 ruby lib

Gem::Specification.new do |s|
  s.name = "geokit"
  s.version = "1.8.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Michael Noack", "James Cox", "Andre Lewis", "Bill Eisenhauer"]
  s.date = "2014-01-12"
  s.description = "Geokit provides geocoding and distance calculation in an easy-to-use API"
  s.email = ["michael+geokit@noack.com.au"]
  s.extra_rdoc_files = ["README.markdown"]
  s.files = ["README.markdown"]
  s.homepage = "http://github.com/geokit/geokit"
  s.licenses = ["MIT"]
  s.rdoc_options = ["--main", "README.markdown"]
  s.require_paths = ["lib"]
  s.rubygems_version = "2.1.10"
  s.summary = "Geokit: encoding and distance calculation gem"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<multi_json>, [">= 1.3.2"])
      s.add_development_dependency(%q<bundler>, ["> 1.0"])
      s.add_development_dependency(%q<simplecov>, [">= 0"])
      s.add_development_dependency(%q<simplecov-rcov>, [">= 0"])
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<mocha>, [">= 0"])
      s.add_development_dependency(%q<coveralls>, [">= 0"])
      s.add_development_dependency(%q<vcr>, [">= 0"])
      s.add_development_dependency(%q<webmock>, [">= 0"])
      s.add_development_dependency(%q<typhoeus>, [">= 0"])
    else
      s.add_dependency(%q<multi_json>, [">= 1.3.2"])
      s.add_dependency(%q<bundler>, ["> 1.0"])
      s.add_dependency(%q<simplecov>, [">= 0"])
      s.add_dependency(%q<simplecov-rcov>, [">= 0"])
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<mocha>, [">= 0"])
      s.add_dependency(%q<coveralls>, [">= 0"])
      s.add_dependency(%q<vcr>, [">= 0"])
      s.add_dependency(%q<webmock>, [">= 0"])
      s.add_dependency(%q<typhoeus>, [">= 0"])
    end
  else
    s.add_dependency(%q<multi_json>, [">= 1.3.2"])
    s.add_dependency(%q<bundler>, ["> 1.0"])
    s.add_dependency(%q<simplecov>, [">= 0"])
    s.add_dependency(%q<simplecov-rcov>, [">= 0"])
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<mocha>, [">= 0"])
    s.add_dependency(%q<coveralls>, [">= 0"])
    s.add_dependency(%q<vcr>, [">= 0"])
    s.add_dependency(%q<webmock>, [">= 0"])
    s.add_dependency(%q<typhoeus>, [">= 0"])
  end
end
