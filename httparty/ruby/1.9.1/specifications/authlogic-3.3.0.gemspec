# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "authlogic"
  s.version = "3.3.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Ben Johnson"]
  s.date = "2013-04-04"
  s.description = "A clean, simple, and unobtrusive ruby authentication solution."
  s.email = ["bjohnson@binarylogic.com"]
  s.homepage = "http://github.com/binarylogic/authlogic"
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.16"
  s.summary = "A clean, simple, and unobtrusive ruby authentication solution."

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activerecord>, [">= 3.2"])
      s.add_runtime_dependency(%q<activesupport>, [">= 3.2"])
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<bcrypt-ruby>, [">= 0"])
      s.add_development_dependency(%q<scrypt>, [">= 0"])
      s.add_development_dependency(%q<sqlite3>, [">= 0"])
      s.add_development_dependency(%q<timecop>, [">= 0"])
      s.add_development_dependency(%q<i18n>, [">= 0"])
    else
      s.add_dependency(%q<activerecord>, [">= 3.2"])
      s.add_dependency(%q<activesupport>, [">= 3.2"])
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<bcrypt-ruby>, [">= 0"])
      s.add_dependency(%q<scrypt>, [">= 0"])
      s.add_dependency(%q<sqlite3>, [">= 0"])
      s.add_dependency(%q<timecop>, [">= 0"])
      s.add_dependency(%q<i18n>, [">= 0"])
    end
  else
    s.add_dependency(%q<activerecord>, [">= 3.2"])
    s.add_dependency(%q<activesupport>, [">= 3.2"])
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<bcrypt-ruby>, [">= 0"])
    s.add_dependency(%q<scrypt>, [">= 0"])
    s.add_dependency(%q<sqlite3>, [">= 0"])
    s.add_dependency(%q<timecop>, [">= 0"])
    s.add_dependency(%q<i18n>, [">= 0"])
  end
end
