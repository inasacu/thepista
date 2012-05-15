# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "ayah_integration"
  s.version = "0.6.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Andrew S Herron"]
  s.date = "2011-12-13"
  s.description = "Integrate the AreYouAHuman.com CAPTCHA alternative human verification into your Ruby/Rails application"
  s.email = "plugins@areyouahuman.com"
  s.homepage = "http://rubygems.org/gems/ayah_integration"
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.16"
  s.summary = "AreYouAHuman.com CAPTCHA alternative integration library"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rest-client>, [">= 0"])
      s.add_runtime_dependency(%q<json>, [">= 0"])
    else
      s.add_dependency(%q<rest-client>, [">= 0"])
      s.add_dependency(%q<json>, [">= 0"])
    end
  else
    s.add_dependency(%q<rest-client>, [">= 0"])
    s.add_dependency(%q<json>, [">= 0"])
  end
end
