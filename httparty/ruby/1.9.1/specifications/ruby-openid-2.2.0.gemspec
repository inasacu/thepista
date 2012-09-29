# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "ruby-openid"
  s.version = "2.2.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["JanRain, Inc"]
  s.autorequire = "openid"
  s.date = "2012-07-07"
  s.email = "openid@janrain.com"
  s.extra_rdoc_files = ["README.md", "INSTALL.md", "LICENSE", "UPGRADE.md"]
  s.files = ["README.md", "INSTALL.md", "LICENSE", "UPGRADE.md"]
  s.homepage = "https://github.com/openid/ruby-openid"
  s.rdoc_options = ["--main", "README.md"]
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.16"
  s.summary = "A library for consuming and serving OpenID identities."

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
