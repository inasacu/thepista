# -*- encoding: utf-8 -*-
# stub: uglifier 2.3.0 ruby lib

Gem::Specification.new do |s|
  s.name = "uglifier"
  s.version = "2.3.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Ville Lautanala"]
  s.date = "2013-10-26"
  s.email = "lautis@gmail.com"
  s.extra_rdoc_files = ["LICENSE.txt", "README.md"]
  s.files = ["LICENSE.txt", "README.md"]
  s.homepage = "http://github.com/lautis/uglifier"
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = "2.1.10"
  s.summary = "Ruby wrapper for UglifyJS JavaScript compressor"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<execjs>, [">= 0.3.0"])
      s.add_runtime_dependency(%q<json>, [">= 1.8.0"])
      s.add_development_dependency(%q<rspec>, ["~> 2.7"])
      s.add_development_dependency(%q<bundler>, ["~> 1.0"])
      s.add_development_dependency(%q<jeweler>, ["~> 1.8.3"])
      s.add_development_dependency(%q<rdoc>, [">= 3.11"])
      s.add_development_dependency(%q<source_map>, [">= 0"])
    else
      s.add_dependency(%q<execjs>, [">= 0.3.0"])
      s.add_dependency(%q<json>, [">= 1.8.0"])
      s.add_dependency(%q<rspec>, ["~> 2.7"])
      s.add_dependency(%q<bundler>, ["~> 1.0"])
      s.add_dependency(%q<jeweler>, ["~> 1.8.3"])
      s.add_dependency(%q<rdoc>, [">= 3.11"])
      s.add_dependency(%q<source_map>, [">= 0"])
    end
  else
    s.add_dependency(%q<execjs>, [">= 0.3.0"])
    s.add_dependency(%q<json>, [">= 1.8.0"])
    s.add_dependency(%q<rspec>, ["~> 2.7"])
    s.add_dependency(%q<bundler>, ["~> 1.0"])
    s.add_dependency(%q<jeweler>, ["~> 1.8.3"])
    s.add_dependency(%q<rdoc>, [">= 3.11"])
    s.add_dependency(%q<source_map>, [">= 0"])
  end
end
