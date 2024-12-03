# frozen_string_literal: true

require 'solidus_core'
require 'solidus_support'

module SolidusOpenPay
  class Engine < Rails::Engine
    include SolidusSupport::EngineExtensions

    isolate_namespace SolidusOpenPay
    engine_name 'solidus_open_pay'

    initializer 'spree.gateway.payment_methods', after: 'spree.register.payment_methods' do |app|
      app.config.spree.payment_methods << 'SolidusOpenPay::PaymentMethod'

      Spree::PermittedAttributes.source_attributes.push(
        :card_number,
        :holder_name,
        :token_id,
        :card_type,
        :brand,
        :points_card,
        :points_type,
        :expiration_month,
        :expiration_year,
        :device_session_id
      )
    end

    # Use rspec for tests
    config.generators do |g|
      g.test_framework :rspec
    end
  end
end
