# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "zurb-foundation"
  s.version = "3.2.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["ZURB"]
  s.date = "2012-12-05"
  s.description = "ZURB Foundation on SASS/Compass"
  s.email = ["foundation@zurb.com"]
  s.homepage = "http://foundation.zurb.com"
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.16"
  s.summary = "ZURB Foundation on SASS/Compass"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<compass>, [">= 0.12.2"])
      s.add_runtime_dependency(%q<sass>, [">= 3.2.0"])
      s.add_runtime_dependency(%q<modular-scale>, [">= 1.0.2"])
      s.add_runtime_dependency(%q<rake>, [">= 0"])
    else
      s.add_dependency(%q<compass>, [">= 0.12.2"])
      s.add_dependency(%q<sass>, [">= 3.2.0"])
      s.add_dependency(%q<modular-scale>, [">= 1.0.2"])
      s.add_dependency(%q<rake>, [">= 0"])
    end
  else
    s.add_dependency(%q<compass>, [">= 0.12.2"])
    s.add_dependency(%q<sass>, [">= 3.2.0"])
    s.add_dependency(%q<modular-scale>, [">= 1.0.2"])
    s.add_dependency(%q<rake>, [">= 0"])
  end
end
