# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "hirefireapp"
  s.version = "0.0.7"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Michael van Rooijen"]
  s.date = "2012-03-02"
  s.description = "HireFireApp.com - The Heroku Process Manager - Autoscaling your web and worker dynos saving you time and money!"
  s.email = "meskyanichi@gmail.com"
  s.executables = ["hirefireapp"]
  s.files = ["bin/hirefireapp"]
  s.homepage = "http://hirefireapp.com/"
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.16"
  s.summary = "HireFireApp.com - The Heroku Process Manager - Autoscaling your web and worker dynos!"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
