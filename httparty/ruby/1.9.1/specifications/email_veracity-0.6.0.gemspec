# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "email_veracity"
  s.version = "0.6.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Carsten Nielsen"]
  s.date = "2010-05-28"
  s.description = "Email Veracity abstracts an email address into a series of objects which makes it easy to see if an address is invalid, and if so, why."
  s.email = "heycarsten@gmail.com"
  s.extra_rdoc_files = ["LICENSE", "README.md"]
  s.files = ["LICENSE", "README.md"]
  s.homepage = "http://github.com/heycarsten/email-veracity"
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.16"
  s.summary = "A simple library for checking the real-world validity of email addresses."

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<mocha>, ["= 0.9.8"])
      s.add_development_dependency(%q<shoulda>, ["= 2.10.3"])
    else
      s.add_dependency(%q<mocha>, ["= 0.9.8"])
      s.add_dependency(%q<shoulda>, ["= 2.10.3"])
    end
  else
    s.add_dependency(%q<mocha>, ["= 0.9.8"])
    s.add_dependency(%q<shoulda>, ["= 2.10.3"])
  end
end
