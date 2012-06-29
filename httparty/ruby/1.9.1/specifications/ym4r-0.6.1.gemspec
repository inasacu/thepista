# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "ym4r"
  s.version = "0.6.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Guilhem Vellut"]
  s.date = "2008-02-07"
  s.description = ""
  s.email = "guilhem.vellut@gmail.com"
  s.extra_rdoc_files = ["README"]
  s.files = ["README"]
  s.homepage = "http://ym4r.rubyforge.org"
  s.rdoc_options = ["--main", "README"]
  s.require_paths = ["lib"]
  s.requirements = ["none"]
  s.rubygems_version = "1.8.16"
  s.summary = "Helping the use of Google Maps and Yahoo! Maps API's from Ruby and Rails"

  if s.respond_to? :specification_version then
    s.specification_version = 2

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
