# frozen_string_literal: true

module SolidusOpenPay
  module Spree
    module OrderDecorator
      def open_pay_payments
        payments.valid.where(
          source_type: 'SolidusOpenPay::PaymentSource',
          state: 'checkout'
        )
      end

      def open_pay_payments?
        open_pay_payments.any?
      end

      def current_open_pay_payment
        open_pay_payments&.first
      end

      def current_open_pay_payment_redirect_url
        current_open_pay_payment&.source&.redirect_url
      end

      ::Spree::Order.prepend(self)
    end
  end
end
