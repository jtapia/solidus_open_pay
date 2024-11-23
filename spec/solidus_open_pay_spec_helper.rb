# frozen_string_literal: true

require 'openpay'

Dir["#{__dir__}/support/solidus_open_pay/**/*.rb"].sort.each { |f| require f }
