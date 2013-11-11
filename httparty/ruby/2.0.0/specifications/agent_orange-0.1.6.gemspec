# -*- encoding: utf-8 -*-
# stub: agent_orange 0.1.6 ruby lib

Gem::Specification.new do |s|
  s.name = "agent_orange"
  s.version = "0.1.6"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Kevin Elliott"]
  s.date = "2013-01-16"
  s.description = "Parse and process User Agents like a secret one"
  s.email = ["kevin@welikeinc.com"]
  s.executables = ["agent_orange_example"]
  s.files = ["bin/agent_orange_example"]
  s.homepage = "http://github.com/kevinelliott/agent_orange"
  s.require_paths = ["lib"]
  s.rubyforge_project = "agent_orange"
  s.rubygems_version = "2.1.10"
  s.summary = "Parse and process User Agents like a secret one"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<rspec>, [">= 0"])
      s.add_development_dependency(%q<bundler>, [">= 0"])
    else
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<rspec>, [">= 0"])
      s.add_dependency(%q<bundler>, [">= 0"])
    end
  else
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<rspec>, [">= 0"])
    s.add_dependency(%q<bundler>, [">= 0"])
  end
end
