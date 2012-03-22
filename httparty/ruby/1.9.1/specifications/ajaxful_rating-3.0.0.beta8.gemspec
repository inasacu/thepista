# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "ajaxful_rating"
  s.version = "3.0.0.beta8"

  s.required_rubygems_version = Gem::Requirement.new("> 1.3.1") if s.respond_to? :required_rubygems_version=
  s.authors = ["Edgar J. Suarez", "Denis Odorcic"]
  s.date = "2012-01-07"
  s.description = "Provides a simple way to add rating functionality to your application."
  s.email = ["edgar.js@gmail.com", "denis.odorcic@gmail.com"]
  s.extra_rdoc_files = ["README.textile"]
  s.files = ["README.textile"]
  s.homepage = "http://github.com/edgarjs/ajaxful-rating"
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.16"
  s.summary = "Provides a simple way to add rating functionality to your application."

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
