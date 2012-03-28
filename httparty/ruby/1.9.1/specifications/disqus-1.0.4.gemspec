# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "disqus"
  s.version = "1.0.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Norman Clarke", "Matthew Van Horn"]
  s.date = "2010-04-21"
  s.description = "Integrates Disqus into your Ruby-powered site. Works with any Ruby website, and has view helpers for Rails and Merb."
  s.email = ["norman@njclarke.com", "mattvanhorn@gmail.com"]
  s.homepage = "http://github.com/norman/disqus"
  s.require_paths = ["lib"]
  s.rubyforge_project = "disqus"
  s.rubygems_version = "1.8.16"
  s.summary = "Integrates Disqus commenting system into your Ruby-powered site."

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<json>, [">= 0"])
      s.add_development_dependency(%q<mocha>, [">= 0"])
    else
      s.add_dependency(%q<json>, [">= 0"])
      s.add_dependency(%q<mocha>, [">= 0"])
    end
  else
    s.add_dependency(%q<json>, [">= 0"])
    s.add_dependency(%q<mocha>, [">= 0"])
  end
end
