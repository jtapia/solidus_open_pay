# frozen_string_literal: true

require_relative 'lib/solidus_open_pay/version'

Gem::Specification.new do |s|
  s.name = 'solidus_open_pay'
  s.version = SolidusOpenPay::VERSION
  s.authors = %w(Jonathan Tapia)
  s.email = %w(jtapia.dev@gmail.com)

  s.summary = 'Solidus Engine for Openpay Mexican Payment Gateway'
  s.homepage = 'http://github.com/jtapia/solidus_open_pay'
  s.license = 'BSD-3-Clause'

  s.metadata['homepage_uri'] = s.homepage
  s.metadata['source_code_uri'] = 'https://github.com/jtapia/solidus_open_pay'
  s.metadata['changelog_uri'] = 'https://github.com/jtapia/solidus_open_pay/blob/master/CHANGELOG.md'

  s.required_ruby_version = Gem::Requirement.new('>= 2.5')

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  files = Dir.chdir(__dir__) { `git ls-files -z`.split("\x0") }

  s.files = files.grep_v(%r{^(test|spec|features)/})
  s.test_files = files.grep(%r{^(test|spec|features)/})
  s.bindir = "exe"
  s.executables = files.grep(%r{^exe/}) { |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency 'deface', '~> 1.5'
  s.add_dependency 'solidus_core', '>= 3.0', '< 5.0'
  s.add_dependency 'solidus_support', '>= 0.8.0'

  s.add_dependency 'openpay'

  s.add_development_dependency 'rails-controller-testing'
  s.add_development_dependency 'solidus_dev_support', '~> 2.5'
end
