# frozen_string_literal: true

require 'openpay'
require 'spec_helper'

# rubocop:disable Style/HashSyntax
RSpec.describe SolidusOpenPay::PaymentMethod, type: :model do
  let(:user) { create(:user) }
  let(:address) do
    create(:address)
  end
  let(:open_pay_payment_method) do
    described_class.create(
      name: 'OpenPay',
      active: true,
      auto_capture: false,
      preferences: {
        server: 'test',
        public_key: 'dummy_public_key',
        private_key: 'dummy_private_key',
        merchant_id: 'dummy_merchant_id',
        country: '',
        test_mode: true
      }
    )
  end
  let(:source) do
    SolidusOpenPay::PaymentSource.create!(
      name: 'User Test',
      device_session_id: 'noycha3iERwYIJCy74Uv57fI0CsfXMU4',
      verification_value: 'ABC123',
      token_id: 'kecujmbb3qyejwju1z30',
      number: '4242',
      expiration_month: '9',
      expiration_year: '29',
      brand: 'visa',
      points_card: true,
      points_type: 'bancomer',
      payment_method: open_pay_payment_method
    )
  end
  let(:order) do
    create(
      :order_with_line_items,
      user: user,
      ship_address: address,
      bill_address: address
    )
  end
  let(:payment) do
    order.payments.create!(
      payment_method: open_pay_payment_method,
      source: source,
      amount: 55
    )
  end

  describe 'preferences' do
    describe 'saving preference hashes as strings' do
      context 'with valid hash syntax' do
        let(:update_params) do
          {
            :server => 'test',
            :test_mode => true,
            :merchant_id => '1',
            :private_key => 'sk_xxxx1',
            :public_key => 'pk_xxxx1',
            :country => '',
            :test => true
          }
        end

        before do
          open_pay_payment_method.update(preferences: update_params)
        end

        it 'successfully updates the preference' do
          expect(open_pay_payment_method.preferred_merchant_id)
              .to eq('1')
          expect(open_pay_payment_method.preferred_private_key)
              .to eq('sk_xxxx1')
          expect(open_pay_payment_method.preferred_public_key)
              .to eq('pk_xxxx1')
        end
      end
    end
  end

  describe '#authorize' do
    let(:authorization_response) do
      {
        'id' => 'triitam7thhlqfvunpsd',
        'authorization' => '801585',
        'operation_type' => 'in',
        'transaction_type' => 'charge',
        'status' => 'in_progress',
        'conciliated' => false,
        'creation_date' => '2024-11-22T13:58:05-06:00',
        'operation_date' => '2024-11-22T13:58:05-06:00',
        'description' => 'Cargo inicial',
        'error_message' => nil,
        'order_id' => 'R709462453-YBR2C8GT',
        'card' => {
          'type' => 'credit',
          'brand' => 'visa',
          'address' => nil,
          'card_number' => '424242XXXXXX4242',
          'holder_name' => 'User Test',
          'expiration_year' => '29',
          'expiration_month' => '09',
          'allows_charges' => true,
          'allows_payouts' => false,
          'bank_name' => 'BANCOMER',
          'points_type' => 'bancomer',
          'card_business_type' => nil,
          'dcc' => nil,
          'bank_code' => '012',
          'points_card' => true
        },
        'gateway_card_present' => 'BANCOMER',
        'amount' => 10.0,
        'customer' => {
          'name' => 'User',
          'last_name' => 'Test',
          'email' => 'admin@example.com',
          'phone_number' => nil,
          'address' => nil,
          'creation_date' => '2024-11-22T13:58:05-06:00',
          'external_id' => nil,
          'clabe' => nil
        },
        'currency' => 'MXN',
        'method' => 'card'
      }
    end

    before do
      allow_any_instance_of(OpenpayApi).to receive(:create)
          .with(:charges) { Charges.new({}, nil, nil) }
      allow_any_instance_of(Charges)
          .to receive(:create) { authorization_response }
    end

    it 'sends an authorize request to open pay' do
      response = open_pay_payment_method.authorize(
        1000,
        source,
        {
          order_id: order.number,
          email: user.email
        }
      )

      expect(response).to be_success
      expect(response.class).to be(SolidusOpenPay::Response)
    end
  end

  describe '#capture' do
    let(:capture_response) do
      {
        'id' => 'triitam7thhlqfvunpsd',
        'authorization' => '801585',
        'operation_type' => 'in',
        'transaction_type' => 'charge',
        'status' => 'completed',
        'conciliated' => false,
        'creation_date' => '2024-11-22T13:58:05-06:00',
        'operation_date' => '2024-11-22T14:01:19-06:00',
        'description' => 'Cargo inicial',
        'error_message' => nil,
        'order_id' => 'R709462453-YBR2C8GT',
        'card' => {
          'type' => 'credit',
          'brand' => 'visa',
          'address' => nil,
          'card_number' => '424242XXXXXX4242',
          'holder_name' => 'User Test',
          'expiration_year' => '29',
          'expiration_month' => '09',
          'allows_charges' => true,
          'allows_payouts' => false,
          'bank_name' => 'BANCOMER',
          'points_type' => 'bancomer',
          'card_business_type' => nil,
          'dcc' => nil,
          'bank_code' => '012',
          'points_card' => true
        },
        'fee' => {
          'amount' => 2.79,
          'tax' => 0.4464,
          'surcharge' => nil,
          'base_commission' => nil,
          'currency' => 'MXN'
        },
        'amount' => 10.0,
        'customer' => {
          'name' => 'User',
          'last_name' => 'Test',
          'email' => 'admin@example.com',
          'phone_number' => nil,
          'address' => nil,
          'creation_date' => '2024-11-22T13:58:06-06:00',
          'external_id' => nil,
          'clabe' => nil
        },
        'currency' => 'MXN',
        'method' => 'card'
      }
    end

    before do
      allow_any_instance_of(Charges)
          .to receive(:capture) { RestClient::Response.new }
      allow_any_instance_of(RestClient::Response)
          .to receive(:body) { capture_response.to_json }
    end

    it 'sends an capture request to open pay' do
      response = open_pay_payment_method.capture(
        1000,
        'triitam7thhlqfvunpsd',
        {
          order_id: order.number,
          email: user.email
        }
      )

      expect(response).to be_success
      expect(response.class).to be(SolidusOpenPay::Response)
    end
  end

  describe '#purchase' do
    let(:purchase_response) do
      {
        'id' => 'tr6jtfjrksvqe1ifqpvy',
        'authorization' => '801585',
        'operation_type' => 'in',
        'transaction_type' => 'charge',
        'status' => 'completed',
        'conciliated' => false,
        'creation_date' => '2024-11-26T16:26:08-06:00',
        'operation_date' => '2024-11-26T16:26:25-06:00',
        'description' => 'Cargo inicial',
        'error_message' => nil,
        'order_id' => 'R069147136-8AK5U5HC',
        'card' =>  {
          'type' => 'credit',
          'brand' => 'visa',
          'address' => nil,
          'card_number' => '424242XXXXXX4242',
          'holder_name' => 'User Test',
          'expiration_year' => '29',
          'expiration_month' => '09',
          'allows_charges' => true,
          'allows_payouts' => false,
          'bank_name' => 'BANCOMER',
          'points_type' => 'bancomer',
          'card_business_type' => nil,
          'dcc' => nil,
          'points_card' => true,
          'bank_code' => '012'
        },
        'amount' => 10.0,
        'currency' => 'MXN',
        'customer' => {
          'name' => 'User',
          'last_name' => 'Test',
          'email' => 'pedidos@donmanolito.com',
          'phone_number' => nil,
          'address' => nil,
          'creation_date' => '2024-11-26T16:26:08-06:00',
          'external_id' => nil,
          'clabe' => nil
        },
        'fee' => {
          'amount' => 2.79,
          'tax' => 0.4464,
          'surcharge' => nil,
          'base_commission' => nil,
          'currency' => 'MXN'
        },
        'method' => 'card'
      }
    end

    before do
      allow_any_instance_of(OpenpayApi).to receive(:create)
          .with(:charges) { Charges.new({}, nil, nil) }
      allow_any_instance_of(Charges)
          .to receive(:create) { purchase_response }
    end

    it 'sends an purchase request to open pay' do
      response = open_pay_payment_method.purchase(
        1000,
        source,
        {
          order_id: order.number,
          email: user.email
        }
      )

      expect(response).to be_success
      expect(response.class).to be(SolidusOpenPay::Response)
    end
  end

  describe '#void' do
    let(:void_response) do
      {
        'id' => 'trhp1prb21hweym5zoxq',
        'authorization' => '801585',
        'operation_type' => 'in',
        'transaction_type' => 'charge',
        'status' => 'cancelled',
        'conciliated' => true,
        'creation_date' => '2024-11-22T22:20:28-06:00',
        'operation_date' => '2024-11-22T22:21:05-06:00',
        'description' => 'Cargo inicial',
        'error_message' => nil,
        'order_id' => 'R161167589-DBHXWAP6',
        'card' =>
        {
          'type' => 'credit',
          'brand' => 'visa',
          'address' => nil,
          'card_number' => '424242XXXXXX4242',
          'holder_name' => 'User Test',
          'expiration_year' => '29',
          'expiration_month' => '09',
          'allows_charges' => true,
          'allows_payouts' => false,
          'bank_name' => 'BANCOMER',
          'points_type' => 'bancomer',
          'card_business_type' => nil,
          'dcc' => nil,
          'points_card' => true,
          'bank_code' => '012'
        },
        'customer' => {
          'name' => 'User',
          'last_name' => 'Test',
          'email' => 'pedidos@donmanolito.com',
          'phone_number' => nil,
          'address' => nil,
          'creation_date' => '2024-11-22T22:20:29-06:00',
          'external_id' => nil,
          'clabe' => nil
        },
        'amount' => 10.0,
        'currency' => 'MXN',
        'method' => 'card'
      }
    end

    before do
      allow_any_instance_of(Charges)
          .to receive(:refund) { void_response }
    end

    it 'sends an void request to open pay' do
      response = open_pay_payment_method.void(
        'triitam7thhlqfvunpsd',
        {}
      )

      expect(response).to be_success
      expect(response.class).to be(SolidusOpenPay::Response)
    end
  end
end
# rubocop:enable Style/HashSyntax
