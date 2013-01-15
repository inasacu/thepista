# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "texticle"
  s.version = "2.1.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Ben Hamill", "ecin", "Aaron Patterson"]
  s.date = "2013-01-12"
  s.description = "Texticle exposes full text search capabilities from PostgreSQL, extending\n    ActiveRecord with scopes making search easy and fun!"
  s.email = ["git-commits@benhamill.com", "ecin@copypastel.com"]
  s.homepage = "http://texticle.github.com/texticle"
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.16"
  s.summary = "Texticle exposes full text search capabilities from PostgreSQL"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<pg>, ["~> 0.11.0"])
      s.add_development_dependency(%q<shoulda>, ["~> 2.11.3"])
      s.add_development_dependency(%q<rake>, ["~> 0.9.0"])
      s.add_development_dependency(%q<pry>, [">= 0"])
      s.add_development_dependency(%q<pry-doc>, [">= 0"])
      s.add_runtime_dependency(%q<activerecord>, ["~> 3.0"])
    else
      s.add_dependency(%q<pg>, ["~> 0.11.0"])
      s.add_dependency(%q<shoulda>, ["~> 2.11.3"])
      s.add_dependency(%q<rake>, ["~> 0.9.0"])
      s.add_dependency(%q<pry>, [">= 0"])
      s.add_dependency(%q<pry-doc>, [">= 0"])
      s.add_dependency(%q<activerecord>, ["~> 3.0"])
    end
  else
    s.add_dependency(%q<pg>, ["~> 0.11.0"])
    s.add_dependency(%q<shoulda>, ["~> 2.11.3"])
    s.add_dependency(%q<rake>, ["~> 0.9.0"])
    s.add_dependency(%q<pry>, [">= 0"])
    s.add_dependency(%q<pry-doc>, [">= 0"])
    s.add_dependency(%q<activerecord>, ["~> 3.0"])
  end
end
