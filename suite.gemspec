# -*- encoding: utf-8 -*-
require File.expand_path('../lib/suite/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Mal Curtis"]
  gem.email         = ["mal@sitepoint.com"]
  gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = ""

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "suite"
  gem.require_paths = ["lib"]
  gem.version       = Suite::VERSION


  gem.add_development_dependency "rspec", "~> 2.6"
  gem.add_dependency "thor"
  gem.add_dependency "goliath"
end
