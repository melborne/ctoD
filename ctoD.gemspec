# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ctoD/version'

Gem::Specification.new do |spec|
  spec.name          = "ctoD"
  spec.version       = CtoD::VERSION
  spec.authors       = ["kyoendo"]
  spec.email         = ["postagie@gmail.com"]
  spec.description   = %q{Create a database table from csv}
  spec.summary       = %q{Create a database table from csv}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
  spec.requied_ruby_version = '>= 2.0.0'

  spec.add_dependency "thor"
  spec.add_dependency "active_record", "~> 3.2"
  spec.add_dependency "mysql2"
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
