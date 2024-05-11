# frozen_string_literal: true

module Decorators
  module Spree
    module Order
      def self.prepended(base)
        #HACK
        Spree::Openpay
        Spree::Openpay::Response
        Spree::Openpay::PaymentSource
        Spree::Openpay::PaymentSource::Card
        Spree::Openpay::PaymentSource::Bank
        Spree::Openpay::PaymentSource::Cash
      end

      def last_payment_details
        YAML.load payments.last.log_entries.last.details
      end

      def last_payment_source
        payments.last.payment_method_source
      end

      Spree::Order.prepend(self)
    end
  end
end
