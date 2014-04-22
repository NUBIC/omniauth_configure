# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "omniauth_configure/version"

Gem::Specification.new do |s|
  s.name = %q{omniauth_configure}
  s.version = OmniAuthConfigure::VERSION

  s.authors = ['John Dzak']
  s.email = %q{j-dzak@northwestern.edu}
  s.description = %q{Allows centralized OmniAuth strategy configurations}
  s.summary = %q{Allows centralized OmniAuth strategy configurations}

  s.files = `git ls-files`.split("\n")
  s.require_paths = ["lib"]
  s.add_runtime_dependency 'omniauth', '~> 1.2'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'rake'
end

