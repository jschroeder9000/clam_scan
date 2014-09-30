# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'clam_scan/version'

Gem::Specification.new do |spec|
  spec.name          = "clam_scan"
  spec.version       = ClamScan::VERSION
  spec.authors       = ["John Schroeder"]
  spec.email         = ["jschroeder@multiadsolutions.com"]
  spec.summary       = %q{Ruby wrapper for ClamAV's clamscan/clamdscan.}
  spec.description   = %q{Ruby wrapper for ClamAV's clamscan/clamdscan.}
  spec.homepage      = "https://github.com/jschroeder9000/clam_scan"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
