# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sigfil/version'

Gem::Specification.new do |spec|
  spec.name          = "sigfil"
  spec.version       = SigFil::VERSION
  spec.authors       = ["Hiroyuki Tanaka"]
  spec.email         = ["hryktnk@ge.com"]

  spec.summary       = %q{Filters for signal processing}
  spec.description   = %q{Filters for signal processing.}

  spec.homepage      = "https://github.com/tanahiro/sigfil"
  spec.license       = "MIT"

  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "https://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
end
