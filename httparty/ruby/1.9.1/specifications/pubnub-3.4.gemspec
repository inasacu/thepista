# -*- encoding: utf-8 -*-
# stub: pubnub 3.4 ruby lib

Gem::Specification.new do |s|
  s.name = "pubnub"
  s.version = "3.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["PubNub"]
  s.date = "2013-10-19"
  s.description = "Ruby anywhere in the world in 250ms with PubNub!"
  s.email = "support@pubnub.com"
  s.homepage = "http://github.com/pubnub/ruby"
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = "2.1.10"
  s.summary = "PubNub Official Ruby gem"

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<eventmachine>, [">= 0"])
      s.add_runtime_dependency(%q<httparty>, [">= 0"])
      s.add_runtime_dependency(%q<persistent_httparty>, [">= 0"])
      s.add_runtime_dependency(%q<em-http-request>, [">= 0"])
      s.add_runtime_dependency(%q<uuid>, ["~> 2.3.5"])
      s.add_runtime_dependency(%q<json>, [">= 0"])
    else
      s.add_dependency(%q<eventmachine>, [">= 0"])
      s.add_dependency(%q<httparty>, [">= 0"])
      s.add_dependency(%q<persistent_httparty>, [">= 0"])
      s.add_dependency(%q<em-http-request>, [">= 0"])
      s.add_dependency(%q<uuid>, ["~> 2.3.5"])
      s.add_dependency(%q<json>, [">= 0"])
    end
  else
    s.add_dependency(%q<eventmachine>, [">= 0"])
    s.add_dependency(%q<httparty>, [">= 0"])
    s.add_dependency(%q<persistent_httparty>, [">= 0"])
    s.add_dependency(%q<em-http-request>, [">= 0"])
    s.add_dependency(%q<uuid>, ["~> 2.3.5"])
    s.add_dependency(%q<json>, [">= 0"])
  end
end
