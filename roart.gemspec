# -*- encoding: utf-8 -*-

Gem::Specification.new do |gem|
  gem.authors       = ["PJ Davis", "Andriy Yanko", "Jais Cheema"]
  gem.email         = ["pj.davis@gmail.com", "andriy.yanko@gmail.com", "jaischeema@gmail.com"]
  gem.description   = %q{Interface for working with Request Tracker (RT) tickets inspired by ActiveRecord.}
  gem.summary       = %q{Interface for working with Request Tracker (RT) tickets inspired by ActiveRecord}
  gem.homepage      = "https://github.com/jaischeema/roart"

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "roart"
  gem.require_paths = ["lib"]
  gem.version       = "0.1.11"

  gem.add_runtime_dependency "mechanize", ">= 1.0.0"
  gem.add_runtime_dependency "activesupport", ">= 2.0.0"
end
