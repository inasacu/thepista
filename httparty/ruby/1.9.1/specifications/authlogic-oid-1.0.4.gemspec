# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "authlogic-oid"
  s.version = "1.0.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Ben Johnson of Binary Logic"]
  s.date = "2009-05-31"
  s.description = "Extension of the Authlogic library to add OpenID support."
  s.email = "bjohnson@binarylogic.com"
  s.extra_rdoc_files = ["Manifest.txt", "CHANGELOG.rdoc", "README.rdoc"]
  s.files = ["Manifest.txt", "CHANGELOG.rdoc", "README.rdoc"]
  s.homepage = "http://github.com/binarylogic/authlogic_openid"
  s.rdoc_options = ["--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = "authlogic-oid"
  s.rubygems_version = "1.8.16"
  s.summary = "Extension of the Authlogic library to add OpenID support."

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<authlogic>, [">= 0"])
      s.add_development_dependency(%q<hoe>, [">= 1.12.2"])
    else
      s.add_dependency(%q<authlogic>, [">= 0"])
      s.add_dependency(%q<hoe>, [">= 1.12.2"])
    end
  else
    s.add_dependency(%q<authlogic>, [">= 0"])
    s.add_dependency(%q<hoe>, [">= 1.12.2"])
  end
end
