# -*- encoding: utf-8 -*-
# stub: authlogic 3.4.0 ruby lib

Gem::Specification.new do |s|
  s.name = "authlogic"
  s.version = "3.4.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Ben Johnson"]
  s.date = "2014-03-03"
  s.description = "A clean, simple, and unobtrusive ruby authentication solution."
  s.email = ["bjohnson@binarylogic.com"]
  s.homepage = "http://github.com/binarylogic/authlogic"
  s.require_paths = ["lib"]
  s.rubygems_version = "2.1.10"
  s.summary = "A clean, simple, and unobtrusive ruby authentication solution."

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activerecord>, [">= 3.2"])
      s.add_runtime_dependency(%q<activesupport>, [">= 3.2"])
      s.add_runtime_dependency(%q<request_store>, ["~> 1.0.5"])
      s.add_development_dependency(%q<rake>, [">= 10.1.1"])
      s.add_development_dependency(%q<bcrypt-ruby>, [">= 3.1.5"])
      s.add_development_dependency(%q<scrypt>, [">= 1.2.0"])
      s.add_development_dependency(%q<sqlite3>, [">= 1.3.9"])
      s.add_development_dependency(%q<timecop>, [">= 0.7.1"])
      s.add_development_dependency(%q<i18n>, [">= 0.6.9"])
    else
      s.add_dependency(%q<activerecord>, [">= 3.2"])
      s.add_dependency(%q<activesupport>, [">= 3.2"])
      s.add_dependency(%q<request_store>, ["~> 1.0.5"])
      s.add_dependency(%q<rake>, [">= 10.1.1"])
      s.add_dependency(%q<bcrypt-ruby>, [">= 3.1.5"])
      s.add_dependency(%q<scrypt>, [">= 1.2.0"])
      s.add_dependency(%q<sqlite3>, [">= 1.3.9"])
      s.add_dependency(%q<timecop>, [">= 0.7.1"])
      s.add_dependency(%q<i18n>, [">= 0.6.9"])
    end
  else
    s.add_dependency(%q<activerecord>, [">= 3.2"])
    s.add_dependency(%q<activesupport>, [">= 3.2"])
    s.add_dependency(%q<request_store>, ["~> 1.0.5"])
    s.add_dependency(%q<rake>, [">= 10.1.1"])
    s.add_dependency(%q<bcrypt-ruby>, [">= 3.1.5"])
    s.add_dependency(%q<scrypt>, [">= 1.2.0"])
    s.add_dependency(%q<sqlite3>, [">= 1.3.9"])
    s.add_dependency(%q<timecop>, [">= 0.7.1"])
    s.add_dependency(%q<i18n>, [">= 0.6.9"])
  end
end
