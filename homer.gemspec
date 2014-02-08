# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'homer/version'

Gem::Specification.new do |spec|
  spec.name          = "homer"
  spec.version       = Homer::VERSION
  spec.authors       = ["Emil Soman"]
  spec.email         = ["emil.soman@gmail.com"]
  spec.homepage      = "https://github.com/emilsoman/homer"
  spec.summary       = "Manage dotfiles like a pro"
  spec.description   = "Homer makes tracking your Unix dotfiles easay peasay - UNDER DEVELOPMENT"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "highline"
  spec.add_dependency "thor"
  spec.add_dependency "github_api"
  spec.add_dependency "terminal-table"
end
