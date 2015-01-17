# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'the_comments_base/version'

Gem::Specification.new do |spec|
  spec.name          = "the_comments_base"
  spec.version       = TheCommentsBase::VERSION
  spec.authors       = ["Ilya N. Zykin"]
  spec.email         = ["zykin-ilya@ya.ru"]
  spec.summary       = %q{Base of TheComments platform}
  spec.description   = %q{Most advanced open source commenting system for Ruby on Rails. Main Module}
  spec.homepage      = "https://github.com/TheComments/the_comments_base"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'aasm', '~> 4.0'
  spec.add_dependency 'awesome_nested_set'
  spec.add_dependency 'the_sortable_tree', '~> 2.5.0'
  spec.add_dependency 'the_notification',  '~> 0.0.1'

  spec.add_dependency 'slim'
  spec.add_dependency 'the_data_role_block_slim'
  spec.add_dependency 'the_data_role_block_jquery'

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
end
