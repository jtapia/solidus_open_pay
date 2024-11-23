# frozen_string_literal: true

module SolidusOpenPay
  module GatewayHelpers
    def new_gateway(opts = {})
      SolidusOpenPay::Gateway.new({
        name: 'OpenPay',
        preferences: {
          environment: 'sandbox',
          public_key: 'dummy_public_key',
          private_key: 'dummy_private_key',
          merchant_id: 'dummy_merchant_id',
          country: nil,
          test_mode: true
        }
      }.merge(opts))
    end

    def create_gateway(opts = {})
      new_gateway(opts).tap(&:save!)
    end
  end
end

RSpec.configure do |config|
  config.include SolidusOpenPay::GatewayHelpers
end
