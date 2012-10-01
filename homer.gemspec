# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "homer"
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Emil Soman"]
  s.date = "2012-10-01"
  s.description = "Homer makes tracking your Unix dotfiles easay peasay - UNDER DEVELOPMENT"
  s.email = "emil.soman@gmail.com"
  s.executables = ["homer"]
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.md",
    "README.rdoc"
  ]
  s.files = [
    ".document",
    ".rspec",
    "Gemfile",
    "LICENSE.txt",
    "README.md",
    "README.rdoc",
    "Rakefile",
    "VERSION",
    "bin/homer",
    "homer.gemspec",
    "lib/homer.rb",
    "lib/homer/file_layer.rb",
    "lib/homer/github_layer.rb",
    "spec/github_layer_spec.rb",
    "spec/homer_spec.rb",
    "spec/spec_helper.rb"
  ]
  s.homepage = "http://github.com/emilsoman/homer"
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.24"
  s.summary = "Homer makes tracking your Unix dotfiles easay peasay - UNDER DEVELOPMENT"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rspec>, [">= 0"])
      s.add_development_dependency(%q<rdoc>, ["~> 3.12"])
      s.add_development_dependency(%q<bundler>, [">= 0"])
      s.add_development_dependency(%q<jeweler>, ["~> 1.8.4"])
    else
      s.add_dependency(%q<rspec>, [">= 0"])
      s.add_dependency(%q<rdoc>, ["~> 3.12"])
      s.add_dependency(%q<bundler>, [">= 0"])
      s.add_dependency(%q<jeweler>, ["~> 1.8.4"])
    end
  else
    s.add_dependency(%q<rspec>, [">= 0"])
    s.add_dependency(%q<rdoc>, ["~> 3.12"])
    s.add_dependency(%q<bundler>, [">= 0"])
    s.add_dependency(%q<jeweler>, ["~> 1.8.4"])
  end
end

