# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "sitemap_generator"
  s.version = "3.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Karl Varga", "Adam Salter"]
  s.date = "2012-01-22"
  s.description = "SitemapGenerator is an XML Sitemap generator written in Ruby with automatic Rails integration.  It supports Video, News, Image and Geo sitemaps and includes Rake tasks for managing your sitemaps."
  s.email = "kjvarga@gmail.com"
  s.homepage = "http://github.com/kjvarga/sitemap_generator"
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.16"
  s.summary = "Easily generate XML Sitemaps"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<mocha>, [">= 0"])
      s.add_development_dependency(%q<nokogiri>, [">= 0"])
      s.add_development_dependency(%q<rspec>, [">= 0"])
      s.add_runtime_dependency(%q<builder>, [">= 0"])
    else
      s.add_dependency(%q<mocha>, [">= 0"])
      s.add_dependency(%q<nokogiri>, [">= 0"])
      s.add_dependency(%q<rspec>, [">= 0"])
      s.add_dependency(%q<builder>, [">= 0"])
    end
  else
    s.add_dependency(%q<mocha>, [">= 0"])
    s.add_dependency(%q<nokogiri>, [">= 0"])
    s.add_dependency(%q<rspec>, [">= 0"])
    s.add_dependency(%q<builder>, [">= 0"])
  end
end
