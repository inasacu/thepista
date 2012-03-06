# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "rpx_now"
  s.version = "0.6.24"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Michael Grosser"]
  s.date = "2011-02-21"
  s.email = "grosser.michael@gmail.com"
  s.homepage = "http://github.com/grosser/rpx_now"
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.16"
  s.summary = "Helper to simplify RPX Now user login/creation"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<json_pure>, [">= 0"])
    else
      s.add_dependency(%q<json_pure>, [">= 0"])
    end
  else
    s.add_dependency(%q<json_pure>, [">= 0"])
  end
end
