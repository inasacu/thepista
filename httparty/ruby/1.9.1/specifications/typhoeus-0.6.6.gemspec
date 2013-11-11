# -*- encoding: utf-8 -*-
# stub: typhoeus 0.6.6 ruby lib

Gem::Specification.new do |s|
  s.name = "typhoeus"
  s.version = "0.6.6"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.3.6") if s.respond_to? :required_rubygems_version=
  s.authors = ["David Balatero", "Paul Dix", "Hans Hasselberg"]
  s.date = "2013-10-31"
  s.description = "Like a modern code version of the mythical beast with 100 serpent heads, Typhoeus runs HTTP requests in parallel while cleanly encapsulating handling logic."
  s.email = ["hans.hasselberg@gmail.com"]
  s.homepage = "https://github.com/typhoeus/typhoeus"
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = "2.1.10"
  s.summary = "Parallel HTTP library on top of libcurl multi."

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<ethon>, ["~> 0.6.1"])
    else
      s.add_dependency(%q<ethon>, ["~> 0.6.1"])
    end
  else
    s.add_dependency(%q<ethon>, ["~> 0.6.1"])
  end
end
