# -*- encoding: utf-8 -*-
# stub: mongoid 3.0.23 ruby lib

Gem::Specification.new do |s|
  s.name = "mongoid"
  s.version = "3.0.23"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.3.6") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Durran Jordan"]
  s.date = "2013-02-24"
  s.description = "Mongoid is an ODM (Object Document Mapper) Framework for MongoDB, written in Ruby."
  s.email = ["durran@gmail.com"]
  s.homepage = "http://mongoid.org"
  s.licenses = ["MIT"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.9")
  s.rubyforge_project = "mongoid"
  s.rubygems_version = "2.2.2"
  s.summary = "Elegant Persistance in Ruby for MongoDB."

  s.installed_by_version = "2.2.2" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activemodel>, ["~> 3.1"])
      s.add_runtime_dependency(%q<tzinfo>, ["~> 0.3.22"])
      s.add_runtime_dependency(%q<moped>, ["~> 1.2"])
      s.add_runtime_dependency(%q<origin>, ["~> 1.0"])
    else
      s.add_dependency(%q<activemodel>, ["~> 3.1"])
      s.add_dependency(%q<tzinfo>, ["~> 0.3.22"])
      s.add_dependency(%q<moped>, ["~> 1.2"])
      s.add_dependency(%q<origin>, ["~> 1.0"])
    end
  else
    s.add_dependency(%q<activemodel>, ["~> 3.1"])
    s.add_dependency(%q<tzinfo>, ["~> 0.3.22"])
    s.add_dependency(%q<moped>, ["~> 1.2"])
    s.add_dependency(%q<origin>, ["~> 1.0"])
  end
end
