# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "modular-scale"
  s.version = "1.0.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.3.6") if s.respond_to? :required_rubygems_version=
  s.authors = ["Scott Kellum", "Adam Stacoviak", "Mason Wendell"]
  s.date = "2012-08-13"
  s.description = "Sassy Modular Scale calculates the incremental values of the modular scale."
  s.email = ["scott@scottkellum.com", "adam@stacoviak.com", "mason@canarypromo.com"]
  s.homepage = "https://github.com/scottkellum/modular-scale"
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.16"
  s.summary = "Sassy Modular Scale calculates the incremental values of the modular scale in proportion to a set size and ratio. Inspired by and adapted from Tim Brown's modularscale.com."

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<compass>, [">= 0.11.5"])
      s.add_runtime_dependency(%q<sassy-math>, [">= 1.2"])
    else
      s.add_dependency(%q<compass>, [">= 0.11.5"])
      s.add_dependency(%q<sassy-math>, [">= 1.2"])
    end
  else
    s.add_dependency(%q<compass>, [">= 0.11.5"])
    s.add_dependency(%q<sassy-math>, [">= 1.2"])
  end
end
