# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "geokit-rails"
  s.version = "1.1.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Andre Lewis", "Bill Eisenhauer"]
  s.date = "2010-09-08"
  s.description = ""
  s.email = ["andre@earthcode.com", "bill@billeisenhauer.com"]
  s.extra_rdoc_files = ["Manifest.txt"]
  s.files = ["Manifest.txt"]
  s.rdoc_options = ["--main", "README.txt"]
  s.require_paths = ["lib"]
  s.rubyforge_project = "geokit-rails"
  s.rubygems_version = "1.8.16"
  s.summary = "Geo distance calculations, distance calculation query support, geocoding for physical and ip addresses."

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<geokit>, [">= 1.5.0"])
      s.add_development_dependency(%q<rubyforge>, [">= 2.0.4"])
      s.add_development_dependency(%q<hoe>, [">= 2.6.2"])
    else
      s.add_dependency(%q<geokit>, [">= 1.5.0"])
      s.add_dependency(%q<rubyforge>, [">= 2.0.4"])
      s.add_dependency(%q<hoe>, [">= 2.6.2"])
    end
  else
    s.add_dependency(%q<geokit>, [">= 1.5.0"])
    s.add_dependency(%q<rubyforge>, [">= 2.0.4"])
    s.add_dependency(%q<hoe>, [">= 2.6.2"])
  end
end
