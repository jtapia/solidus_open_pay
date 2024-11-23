# frozen_string_literal: true

FactoryBot.define do
  factory :open_pay_payment_method, class: 'SolidusOpenPay::PaymentMethod' do
    type { 'SolidusOpenPay::PaymentMethod' }
    name { 'OpenPay Payment Method' }
    preferences {
      {
        merchant_id: SecureRandom.hex(8),
        private_key: SecureRandom.hex(10),
        public_key: 'disabled',
        country: false,
        test_mode: true
      }
    }
  end
end
