# frozen_string_literal: true

require_relative 'lib/solidus_openpay/version'

Gem::Specification.new do |s|
  s.name = 'solidus_openpay'
  s.version = SolidusOpenpay::VERSION
  s.authors = [
      'Jonathan Garay',
      'Fernando Barajas',
      'Manuel Vidaurre',
      'AngelChaos26',
      'Jonathan Tapia'
  ]
  s.email = %w(
      jonathan.garay@crowdint.com
      fernando.barajas@crowdint.com
      manuel.vidaurre@agiltec.com.mx
      jtapia.dev@gmail.com
  )

  s.summary = 'Solidus Engine for Openpay Mexican Payment Gateway'
  s.homepage = 'http://github.com/jtapia/solidus_openpay'
  s.license = 'BSD-3-Clause'

  s.metadata['homepage_uri'] = s.homepage
  s.metadata['source_code_uri'] = 'https://github.com/jtapia/solidus_openpay'
  s.metadata['changelog_uri'] = 'https://github.com/jtapia/solidus_openpay/blob/master/CHANGELOG.md'

  s.required_ruby_version = Gem::Requirement.new('>= 2.4.0')

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  files = Dir.chdir(__dir__) { `git ls-files -z`.split("\x0") }

  s.files = files.grep_v(%r{^(test|spec|features)/})
  s.test_files = files.grep(%r{^(test|spec|features)/})
  s.bindir = 'exe'
  s.executables = files.grep(%r{^exe/}) { |f| File.basename(f) }
  s.require_paths = ['lib']

  s.add_dependency 'solidus_core'
  s.add_dependency 'solidus_support', '~> 0.5'

  # s.add_dependency 'oj'
  # s.add_dependency 'faraday'
  # s.add_dependency 'typhoeus'
  # s.add_dependency 'faraday_middleware'
  s.add_dependency 'activemerchant'
  # s.add_dependency 'coffee-rails'
  # s.add_dependency 'celluloid'
end
