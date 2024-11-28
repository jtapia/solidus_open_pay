# frozen_string_literal: true

FactoryBot.define do
  factory :open_pay_payment_method, class: 'SolidusOpenPay::PaymentMethod' do
    type { 'SolidusOpenPay::PaymentMethod' }
    name { 'OpenPay Payment Method' }
    active { true }
    auto_capture  { false }
    preferences {
      {
        server: 'test',
        public_key: SecureRandom.hex(10),
        private_key: SecureRandom.hex(10),
        merchant_id: SecureRandom.hex(8),
        country: '',
        redirect_url: '',
        test_mode: true
      }
    }
  end

  factory :open_pay_payment_source, class: 'SolidusOpenPay::PaymentSource' do
    name { 'User Test' }
    device_session_id { 'noycha3iERwYIJCy74Uv57fI0CsfXMU4' }
    verification_value { 'ABC123' }
    token_id { SecureRandom.hex(10) }
    number { '4242' }
    expiration_month { '9' }
    expiration_year { '29' }
    brand { 'visa' }
    points_card { true }
    points_type { 'bancomer' }
    payment_method { create(:open_pay_payment_method) }
  end
end
