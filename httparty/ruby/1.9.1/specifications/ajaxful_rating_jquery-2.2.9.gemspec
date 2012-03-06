# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "ajaxful_rating_jquery"
  s.version = "2.2.9"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jack Chu, Edgar J. Suarez"]
  s.date = "2010-09-30"
  s.description = "Provides a simple way to add rating functionality to your application. This is a fork of ajaxful_ratings that works with jQuery instead of Prototype and uses unobtrusive javascript instead of link_to_remote."
  s.email = "kamuigt@gmail.com"
  s.extra_rdoc_files = ["CHANGELOG", "README.textile", "lib/ajaxful_rating_jquery.rb", "lib/axr/css_builder.rb", "lib/axr/errors.rb", "lib/axr/helpers.rb", "lib/axr/locale.rb", "lib/axr/model.rb", "lib/axr/stars_builder.rb"]
  s.files = ["CHANGELOG", "README.textile", "lib/ajaxful_rating_jquery.rb", "lib/axr/css_builder.rb", "lib/axr/errors.rb", "lib/axr/helpers.rb", "lib/axr/locale.rb", "lib/axr/model.rb", "lib/axr/stars_builder.rb"]
  s.homepage = "http://github.com/kamui/ajaxful_rating_jquery"
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Ajaxful_rating_jquery", "--main", "README.textile"]
  s.require_paths = ["lib"]
  s.rubyforge_project = "ajaxful_rating_jquery"
  s.rubygems_version = "1.8.16"
  s.summary = "Add star rating functionality to your Rails 2.3.x application. Requires jQuery."

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
