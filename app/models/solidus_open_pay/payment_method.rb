# frozen_string_literal: true

module SolidusOpenPay
  class PaymentMethod < ::Spree::PaymentMethod
    preference :merchant_id, :string
    preference :private_key, :string
    preference :public_key, :string
    preference :country, :string
    preference :secure_3d, :boolean
    preference :redirect_url, :string, default: '/checkout/confirm'

    def partial_name
      'open_pay'
    end

    def source_required?
      true
    end

    def payment_source_class
      PaymentSource
    end

    def gateway_class
      Gateway
    end

    def payment_profiles_supported?
      false
    end
  end
end
