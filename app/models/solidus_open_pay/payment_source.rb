# frozen_string_literal: true

module SolidusOpenPay
  class PaymentSource < ::Spree::PaymentSource
    include ::SolidusOpenPay::AttributesAccess

    self.table_name = 'open_pay_sources'

    def actions
      %w[capture void credit]
    end

    def can_capture?(payment)
      payment.pending? || payment.checkout?
    end

    def can_void?(payment)
      can_capture?(payment)
    end

    def can_credit?(payment)
      payment.completed? && payment.credit_allowed.positive?
    end
  end
end
