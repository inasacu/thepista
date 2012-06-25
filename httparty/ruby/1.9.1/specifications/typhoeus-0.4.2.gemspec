# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "typhoeus"
  s.version = "0.4.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.3.6") if s.respond_to? :required_rubygems_version=
  s.authors = ["David Balatero", "Paul Dix", "Hans Hasselberg"]
  s.date = "2012-06-09"
  s.description = "Like a modern code version of the mythical beast with 100 serpent heads, Typhoeus runs HTTP requests in parallel while cleanly encapsulating handling logic."
  s.email = ["hans.hasselberg@gmail.com"]
  s.homepage = "https://github.com/typhoeus/typhoeus"
  s.require_paths = ["lib"]
  s.rubyforge_project = "[none]"
  s.rubygems_version = "1.8.16"
  s.summary = "Parallel HTTP library on top of libcurl multi."

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<ffi>, ["~> 1.0"])
      s.add_runtime_dependency(%q<mime-types>, ["~> 1.18"])
      s.add_development_dependency(%q<sinatra>, ["~> 1.3"])
      s.add_development_dependency(%q<json>, ["~> 1.7"])
      s.add_development_dependency(%q<rake>, ["~> 0.9"])
      s.add_development_dependency(%q<mocha>, ["~> 0.10"])
      s.add_development_dependency(%q<rspec>, ["~> 2.10"])
      s.add_development_dependency(%q<guard-rspec>, ["~> 0.6"])
    else
      s.add_dependency(%q<ffi>, ["~> 1.0"])
      s.add_dependency(%q<mime-types>, ["~> 1.18"])
      s.add_dependency(%q<sinatra>, ["~> 1.3"])
      s.add_dependency(%q<json>, ["~> 1.7"])
      s.add_dependency(%q<rake>, ["~> 0.9"])
      s.add_dependency(%q<mocha>, ["~> 0.10"])
      s.add_dependency(%q<rspec>, ["~> 2.10"])
      s.add_dependency(%q<guard-rspec>, ["~> 0.6"])
    end
  else
    s.add_dependency(%q<ffi>, ["~> 1.0"])
    s.add_dependency(%q<mime-types>, ["~> 1.18"])
    s.add_dependency(%q<sinatra>, ["~> 1.3"])
    s.add_dependency(%q<json>, ["~> 1.7"])
    s.add_dependency(%q<rake>, ["~> 0.9"])
    s.add_dependency(%q<mocha>, ["~> 0.10"])
    s.add_dependency(%q<rspec>, ["~> 2.10"])
    s.add_dependency(%q<guard-rspec>, ["~> 0.6"])
  end
end
