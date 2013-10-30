# -*- encoding: utf-8 -*-
# stub: newrelic_rpm 3.6.8.168 ruby lib

Gem::Specification.new do |s|
  s.name = "newrelic_rpm"
  s.version = "3.6.8.168"

  s.required_rubygems_version = Gem::Requirement.new("> 1.3.1") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jason Clark", "Sam Goldstein", "Jonan Scheffler", "Ben Weintraub"]
  s.cert_chain = ["-----BEGIN CERTIFICATE-----\nMIIDODCCAiCgAwIBAgIBADANBgkqhkiG9w0BAQUFADBCMREwDwYDVQQDDAhzZWN1\ncml0eTEYMBYGCgmSJomT8ixkARkWCG5ld3JlbGljMRMwEQYKCZImiZPyLGQBGRYD\nY29tMB4XDTEzMDIxMjE5MDcwN1oXDTE0MDIxMjE5MDcwN1owQjERMA8GA1UEAwwI\nc2VjdXJpdHkxGDAWBgoJkiaJk/IsZAEZFghuZXdyZWxpYzETMBEGCgmSJomT8ixk\nARkWA2NvbTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAJyYRvlk1XUo\n8JhWQcE/v6RmpK//JbeKvTKnmWVUKz5oTDSOg/LKEhzChpJJVSOMJHCxd4OoxkIN\npjQF5U2af1m5ONeN1j4p4MujbwNeqxsJmixGLK/BZ9xTnbpYAa6xCRN1UfEcu3O9\njjLHX3c63ghldwRBn/c2ZD6anMtDeq3C5MLiycFs9h7JXOa3cTTHLZknkYIoHMKN\nEFri5zlks50lbeaVvFRm4IMrYWRsEwzLZWaMOy68BVZe0UlBBKSMnzJfWkbdRRcm\nxqu7viu4hrrCGjUmdHKnl6tf7BY7wqQyKjj+O5DhayKmKRuQcEX8QVnsM+ayqiVU\nEtMiwNScUnsCAwEAAaM5MDcwCQYDVR0TBAIwADAdBgNVHQ4EFgQUOauaMsU0Elp6\nhiUisj4l63ZunSUwCwYDVR0PBAQDAgSwMA0GCSqGSIb3DQEBBQUAA4IBAQAuwrHh\njOjIfAQoEbGakiwHTeImqmC1EjBEWb1+U+rC2OcsSQ3+2Q0mGq2u3lAphAeLa6i5\nWXb5OdQqZY2aI7NgMxRG98/+TcIlAT8tDR0e6/+QBlBuDXP3YI5Nuhp5U4LEvghr\njEPaEo0AFPc1JpSO/zKmktU+e9VRAE+q55gLthP8fe0uZvtGUn0KgDbXJyOuGlHF\nJ93N937OcyA2rD8gR1qkr3/0/we1dwLZnL6kN4p8nGzPgXZgOHsmTdYZ2ryYowtb\nKc9+v+QxnbZYpu2IaPXOvm3T8G4O6qZvhnLh/Uien++Dj8eFBecTPoM8pVjK3ph5\nn/EwuZCcE6ghtCCM\n-----END CERTIFICATE-----\n"]
  s.date = "2013-10-19"
  s.description = "New Relic is a performance management system, developed by New Relic,\nInc (http://www.newrelic.com).  New Relic provides you with deep\ninformation about the performance of your web application as it runs\nin production. The New Relic Ruby Agent is dual-purposed as a either a\nGem or plugin, hosted on\nhttp://github.com/newrelic/rpm/\n"
  s.email = "support@newrelic.com"
  s.executables = ["mongrel_rpm", "newrelic_cmd", "newrelic", "nrdebug"]
  s.extra_rdoc_files = ["CHANGELOG", "LICENSE", "README.md", "GUIDELINES_FOR_CONTRIBUTING.md", "newrelic.yml"]
  s.files = ["bin/mongrel_rpm", "bin/newrelic_cmd", "bin/newrelic", "bin/nrdebug", "CHANGELOG", "LICENSE", "README.md", "GUIDELINES_FOR_CONTRIBUTING.md", "newrelic.yml"]
  s.homepage = "http://www.github.com/newrelic/rpm"
  s.post_install_message = "# New Relic Ruby Agent Release Notes #\n\n## v3.6.8 ##\n\n* X-Ray Sessions support\n\n  X-Ray Sessions provide more targeted transaction trace samples and thread\n  profiling for web transactions. For full details see our X-Ray sessions\n  documentation at https://newrelic.com/docs/site/xray-sessions.\n\n* CPU metrics re-enabled for JRuby >= 1.7.0\n\n  To work around a JRuby bug, the Ruby agent stopped gathering CPU metrics on\n  that platform.  With the bug fixed, the agent can gather those metrics again.\n  Thanks Bram de Vries for the contribution!\n\n* Missing Resque transaction traces (3.6.8.168)\n\n  A bug in 3.6.8.164 prevented transaction traces in Resque jobs from being\n  communicated back to New Relic. 3.6.8.168 fixes this.\n\n* Retry on initial connect (3.6.8.168)\n\n  Failure to contact New Relic on agent start-up would not properly retry. This\n  has been fixed.\n\n* Fix potential memory leak on failure to send to New Relic (3.6.8.168)\n\n  3.6.8.164 introduced a potential memory leak when transmission of some kinds\n  of data to New Relic servers failed. 3.6.8.168 fixes this.\n\nSee https://github.com/newrelic/rpm/blob/master/CHANGELOG for a full list of\nchanges.\n"
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "New Relic Ruby Agent"]
  s.require_paths = ["lib"]
  s.rubygems_version = "2.1.10"
  s.summary = "New Relic Ruby Agent"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rake>, ["= 10.1.0"])
      s.add_development_dependency(%q<minitest>, ["~> 4.7.5"])
      s.add_development_dependency(%q<mocha>, ["~> 0.13.0"])
      s.add_development_dependency(%q<sdoc-helpers>, [">= 0"])
      s.add_development_dependency(%q<rdoc>, [">= 2.4.2"])
      s.add_development_dependency(%q<rails>, ["~> 3.2.13"])
      s.add_development_dependency(%q<sqlite3>, [">= 0"])
      s.add_development_dependency(%q<sequel>, ["~> 3.46.0"])
      s.add_development_dependency(%q<pry>, [">= 0"])
      s.add_development_dependency(%q<guard>, [">= 0"])
      s.add_development_dependency(%q<guard-test>, [">= 0"])
      s.add_development_dependency(%q<rb-fsevent>, ["~> 0.9.1"])
    else
      s.add_dependency(%q<rake>, ["= 10.1.0"])
      s.add_dependency(%q<minitest>, ["~> 4.7.5"])
      s.add_dependency(%q<mocha>, ["~> 0.13.0"])
      s.add_dependency(%q<sdoc-helpers>, [">= 0"])
      s.add_dependency(%q<rdoc>, [">= 2.4.2"])
      s.add_dependency(%q<rails>, ["~> 3.2.13"])
      s.add_dependency(%q<sqlite3>, [">= 0"])
      s.add_dependency(%q<sequel>, ["~> 3.46.0"])
      s.add_dependency(%q<pry>, [">= 0"])
      s.add_dependency(%q<guard>, [">= 0"])
      s.add_dependency(%q<guard-test>, [">= 0"])
      s.add_dependency(%q<rb-fsevent>, ["~> 0.9.1"])
    end
  else
    s.add_dependency(%q<rake>, ["= 10.1.0"])
    s.add_dependency(%q<minitest>, ["~> 4.7.5"])
    s.add_dependency(%q<mocha>, ["~> 0.13.0"])
    s.add_dependency(%q<sdoc-helpers>, [">= 0"])
    s.add_dependency(%q<rdoc>, [">= 2.4.2"])
    s.add_dependency(%q<rails>, ["~> 3.2.13"])
    s.add_dependency(%q<sqlite3>, [">= 0"])
    s.add_dependency(%q<sequel>, ["~> 3.46.0"])
    s.add_dependency(%q<pry>, [">= 0"])
    s.add_dependency(%q<guard>, [">= 0"])
    s.add_dependency(%q<guard-test>, [">= 0"])
    s.add_dependency(%q<rb-fsevent>, ["~> 0.9.1"])
  end
end
