# -*- encoding: utf-8 -*-
$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)
require 'q/version'

Gem::Specification.new do |s|
  s.name        = "Q"
  s.version     = Q::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = []
  s.email       = []
  s.homepage    = "http://rubygems.org/gems/q"
  s.summary     = "Fast, fun, east HTML generation from Ruby"
  s.description = "Fast, fun, east HTML generation from Ruby"

  s.required_rubygems_version = ">= 1.3.6"
  s.rubyforge_project         = "Q"

  s.add_dependency 'escape_utils', ">= 0.1.5"
  s.add_development_dependency "bundler", ">= 1.0.0.rc.3"

  s.files        = `git ls-files`.split("\n")
  s.executables  = `git ls-files`.split("\n").select{|f| f =~ /^bin/}
  s.require_path = 'lib'
end