# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "texticle"
  s.version = "2.0.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["ecin", "Aaron Patterson"]
  s.date = "2011-08-30"
  s.description = "Texticle exposes full text search capabilities from PostgreSQL, extending\n    ActiveRecord with scopes making search easy and fun!"
  s.email = ["ecin@copypastel.com"]
  s.extra_rdoc_files = ["Manifest.txt", "CHANGELOG.rdoc", "README.rdoc"]
  s.files = ["Manifest.txt", "CHANGELOG.rdoc", "README.rdoc"]
  s.homepage = "http://tenderlove.github.com/texticle"
  s.rdoc_options = ["--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = "texticle"
  s.rubygems_version = "1.8.16"
  s.summary = "Texticle exposes full text search capabilities from PostgreSQL"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<pg>, ["~> 0.11.0"])
      s.add_development_dependency(%q<shoulda>, ["~> 2.11.3"])
      s.add_development_dependency(%q<rake>, ["~> 0.8.0"])
      s.add_development_dependency(%q<ruby-debug19>, ["~> 0.11.6"])
      s.add_runtime_dependency(%q<activerecord>, ["~> 3.0"])
    else
      s.add_dependency(%q<pg>, ["~> 0.11.0"])
      s.add_dependency(%q<shoulda>, ["~> 2.11.3"])
      s.add_dependency(%q<rake>, ["~> 0.8.0"])
      s.add_dependency(%q<ruby-debug19>, ["~> 0.11.6"])
      s.add_dependency(%q<activerecord>, ["~> 3.0"])
    end
  else
    s.add_dependency(%q<pg>, ["~> 0.11.0"])
    s.add_dependency(%q<shoulda>, ["~> 2.11.3"])
    s.add_dependency(%q<rake>, ["~> 0.8.0"])
    s.add_dependency(%q<ruby-debug19>, ["~> 0.11.6"])
    s.add_dependency(%q<activerecord>, ["~> 3.0"])
  end
end
