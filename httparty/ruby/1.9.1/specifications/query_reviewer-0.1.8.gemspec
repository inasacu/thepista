# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "query_reviewer"
  s.version = "0.1.8"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["dsboulder, nesquena"]
  s.date = "2013-02-08"
  s.description = "Runs explain before each select query and displays results in an overlayed div"
  s.email = "nesquena@gmail.com"
  s.homepage = "https://github.com/nesquena/query_reviewer"
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.16"
  s.summary = "Runs explain before each select query and displays results in an overlayed div"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
