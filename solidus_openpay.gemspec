# encoding: UTF-8
$:.push File.expand_path('../lib', __FILE__)
require 'solidus_openpay/version'

Gem::Specification.new do |s|
  s.name        = 'solidus_openpay'
  s.version     = SolidusOpenpay::VERSION
  s.authors     = ['Jonathan Garay', 'Fernando Barajas', 'Manuel Vidaurre', 'AngelChaos26']
  s.email       = %w(jonathan.garay@crowdint.com fernando.barajas@crowdint.com manuel.vidaurre@agiltec.com.mx)
  s.homepage    = 'http://github.com/crowdint/spree_conekta'
  s.summary     = 'Solidus Engine for Openpay Mexican Payment gateway'
  s.description = 'Solidus Engine for Openpay Mexican Payment gateway'

  s.files = Dir['{app,config,models,db,lib}/**/*'] + %w(MIT-LICENSE Rakefile README.md)

  s.add_dependency "solidus", "~> 1.2"

  s.add_dependency 'oj'
  s.add_dependency 'faraday'
  s.add_dependency 'typhoeus'
  s.add_dependency 'faraday_middleware'
  s.add_dependency 'activemerchant'
  s.add_dependency 'coffee-rails'
  s.add_dependency 'celluloid'
end