# -*- encoding: utf-8 -*-
# stub: validates_timeliness 3.0.14 ruby lib

Gem::Specification.new do |s|
  s.name = "validates_timeliness"
  s.version = "3.0.14"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Adam Meehan"]
  s.date = "2012-08-22"
  s.description = "Adds validation methods to ActiveModel for validating dates and times. Works with multiple ORMS."
  s.email = "adam.meehan@gmail.com"
  s.extra_rdoc_files = ["README.rdoc", "CHANGELOG.rdoc", "LICENSE"]
  s.files = ["CHANGELOG.rdoc", "LICENSE", "README.rdoc"]
  s.homepage = "http://github.com/adzap/validates_timeliness"
  s.rubygems_version = "2.2.2"
  s.summary = "Date and time validation plugin for Rails which allows custom formats"

  s.installed_by_version = "2.2.2" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<timeliness>, ["~> 0.3.6"])
    else
      s.add_dependency(%q<timeliness>, ["~> 0.3.6"])
    end
  else
    s.add_dependency(%q<timeliness>, ["~> 0.3.6"])
  end
end
