# -*- encoding: utf-8 -*-
require File.expand_path('../lib/billing/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Adman65"]
  gem.email         = ["adman1965@gmail.com"]
  gem.description   = %q{Lightweight interface for managing financial standing in side your application}
  gem.summary       = %q{}
  gem.homepage      = "https://github.com/adman65/billing"

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "billing"
  gem.require_paths = ["lib"]
  gem.version       = Billing::VERSION

  gem.add_dependency 'activesupport', '~> 3.0.0'
  gem.add_dependency 'activemodel'
  gem.add_dependency 'i18n'

  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'simplecov'
end
