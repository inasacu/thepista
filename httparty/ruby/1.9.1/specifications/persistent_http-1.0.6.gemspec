# -*- encoding: utf-8 -*-
# stub: persistent_http 1.0.6 ruby lib

Gem::Specification.new do |s|
  s.name = "persistent_http"
  s.version = "1.0.6"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Brad Pardee"]
  s.date = "2013-09-11"
  s.description = "Persistent HTTP connections using a connection pool"
  s.email = ["bradpardee@gmail.com"]
  s.homepage = "http://github.com/bpardee/persistent_http"
  s.require_paths = ["lib"]
  s.rubygems_version = "2.1.10"
  s.summary = "Persistent HTTP connections using a connection pool"

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<gene_pool>, [">= 1.3"])
    else
      s.add_dependency(%q<gene_pool>, [">= 1.3"])
    end
  else
    s.add_dependency(%q<gene_pool>, [">= 1.3"])
  end
end
