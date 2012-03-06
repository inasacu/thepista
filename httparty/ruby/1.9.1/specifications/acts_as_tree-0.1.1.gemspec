# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "acts_as_tree"
  s.version = "0.1.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Erik Dahlstrand", "Rails Core"]
  s.date = "2010-02-04"
  s.description = "Specify this acts_as extension if you want to model a tree structure by providing a parent association and a children association."
  s.email = "erik.dahlstrand@gmail.com"
  s.extra_rdoc_files = ["README.rdoc"]
  s.files = ["README.rdoc"]
  s.homepage = "http://github.com/erdah/acts_as_tree"
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.16"
  s.summary = "Gem version of acts_as_tree Rails plugin."

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
