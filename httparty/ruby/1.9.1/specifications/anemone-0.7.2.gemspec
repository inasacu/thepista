# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "anemone"
  s.version = "0.7.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Chris Kite"]
  s.date = "2012-05-30"
  s.executables = ["anemone"]
  s.extra_rdoc_files = ["README.rdoc"]
  s.files = ["bin/anemone", "README.rdoc"]
  s.homepage = "http://anemone.rubyforge.org"
  s.rdoc_options = ["-m", "README.rdoc", "-t", "Anemone"]
  s.require_paths = ["lib"]
  s.rubyforge_project = "anemone"
  s.rubygems_version = "1.8.16"
  s.summary = "Anemone web-spider framework"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<nokogiri>, [">= 1.3.0"])
      s.add_runtime_dependency(%q<robotex>, [">= 1.0.0"])
      s.add_development_dependency(%q<rake>, [">= 0.9.2"])
      s.add_development_dependency(%q<rdoc>, [">= 3.12"])
      s.add_development_dependency(%q<rspec>, [">= 2.8.0"])
      s.add_development_dependency(%q<fakeweb>, [">= 1.3.0"])
      s.add_development_dependency(%q<redis>, [">= 2.2.0"])
      s.add_development_dependency(%q<mongo>, [">= 1.3.1"])
      s.add_development_dependency(%q<bson_ext>, [">= 1.3.1"])
      s.add_development_dependency(%q<tokyocabinet>, [">= 1.29"])
      s.add_development_dependency(%q<kyotocabinet-ruby>, [">= 1.27.1"])
      s.add_development_dependency(%q<sqlite3>, [">= 1.3.4"])
    else
      s.add_dependency(%q<nokogiri>, [">= 1.3.0"])
      s.add_dependency(%q<robotex>, [">= 1.0.0"])
      s.add_dependency(%q<rake>, [">= 0.9.2"])
      s.add_dependency(%q<rdoc>, [">= 3.12"])
      s.add_dependency(%q<rspec>, [">= 2.8.0"])
      s.add_dependency(%q<fakeweb>, [">= 1.3.0"])
      s.add_dependency(%q<redis>, [">= 2.2.0"])
      s.add_dependency(%q<mongo>, [">= 1.3.1"])
      s.add_dependency(%q<bson_ext>, [">= 1.3.1"])
      s.add_dependency(%q<tokyocabinet>, [">= 1.29"])
      s.add_dependency(%q<kyotocabinet-ruby>, [">= 1.27.1"])
      s.add_dependency(%q<sqlite3>, [">= 1.3.4"])
    end
  else
    s.add_dependency(%q<nokogiri>, [">= 1.3.0"])
    s.add_dependency(%q<robotex>, [">= 1.0.0"])
    s.add_dependency(%q<rake>, [">= 0.9.2"])
    s.add_dependency(%q<rdoc>, [">= 3.12"])
    s.add_dependency(%q<rspec>, [">= 2.8.0"])
    s.add_dependency(%q<fakeweb>, [">= 1.3.0"])
    s.add_dependency(%q<redis>, [">= 2.2.0"])
    s.add_dependency(%q<mongo>, [">= 1.3.1"])
    s.add_dependency(%q<bson_ext>, [">= 1.3.1"])
    s.add_dependency(%q<tokyocabinet>, [">= 1.29"])
    s.add_dependency(%q<kyotocabinet-ruby>, [">= 1.27.1"])
    s.add_dependency(%q<sqlite3>, [">= 1.3.4"])
  end
end
