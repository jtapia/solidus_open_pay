# frozen_string_literal: true

require 'spec_helper'

# rubocop:disable Style/HashSyntax
RSpec.describe SolidusOpenPay::PaymentsController, type: :request do
  let(:user) { create(:user) }
  let(:address) do
    create(:address)
  end
  let(:open_pay_payment_method) do
    create(:open_pay_payment_method)
  end
  let(:source) do
    create(
      :open_pay_payment_source,
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

  describe '#create' do
    context 'with correct params' do
      let(:params) do
        {
          'payment' => {
            'brand' => 'visa',
            'card_number' => '411111XXXXXX1111',
            'card_type' => 'debit',
            'device_session_id' => 'FSUXY6J3EWmnoniXUAGbtcEq1OWfIHXS',
            'expiration_month' => '09',
            'expiration_year' => '29',
            'holder_name' => 'User Test',
            'payment_method_id' => open_pay_payment_method.id,
            'token_id' => 'koqf5fpphbu8tpnh96nq'
          }
        }
      end
      let(:purchase_charge_response) do
        {
          'id' => 'trhsxgdiecqnvyxrtzqt',
          'authorization' => '',
          'operation_type' => 'in',
          'transaction_type' => 'charge',
          'status' => 'charge_pending',
          'conciliated' => false,
          'creation_date' => '2024-12-02T23:32:35-06:00',
          'operation_date' => '2024-12-02T23:32:36-06:00',
          'description' => 'Cargo inicial',
          'error_message' => nil,
          'order_id' => 'R957933872-Z86PG56N',
          'card' => {
            'type' => 'debit',
            'brand' => 'visa',
            'address' => nil,
            'card_number' => '411111XXXXXX1111',
            'holder_name' => 'User Test',
            'expiration_year' => '29',
            'expiration_month' => '09',
            'allows_charges' => true,
            'allows_payouts' => true,
            'bank_name' => 'Banamex',
            'card_business_type' => nil,
            'dcc' => nil,
            'bank_code' => '002'
          },
          'gateway_card_present' => 'BANCOMER',
          'amount' => 10.0,
          'customer' => {
            'name' => 'User',
            'last_name' => 'Test',
            'email' => 'admin@example.com',
            'phone_number' => '55555555',
            'address' => nil,
            'creation_date' => '2024-12-02T23:32:35-06:00',
            'external_id' => nil,
            'clabe' => nil
          },
          'payment_method' => {
            'type' => 'redirect',
            'url' => 'https://sandbox-api.openpay.mx/v1/md25ixgxorznztcl1hzy/charges/trhsxgdiecqnvyxrtzqt/redirect'
          },
          'currency' => 'MXN',
          'method' => 'card'
        }
      end

      before do
        allow_any_instance_of(described_class)
            .to receive(:current_order).and_return(order)
        allow_any_instance_of(Charges)
            .to receive(:create).and_return(purchase_charge_response)
      end

      it 'returns redirect url' do
        post '/solidus_open_pay/payments.json', params: params

        parsed_response = JSON.parse(response.body)
        expect(parsed_response['redirect_url']).not_to be_empty
      end
    end

    context 'with incorrect params' do
      let(:params) do
        {
          'payment' => {
            'brand' => 'visa',
            'card_number' => '400000XXXXXX0044',
            'card_type' => 'debit',
            'device_session_id' => 'VpY7sTPlk3wWp7kiBgFU7XEtZZIxkzqq',
            'expiration_month' => '09',
            'expiration_year' => '29',
            'holder_name' => 'User Test',
            'payment_method_id' => open_pay_payment_method.id,
            'token_id' => 'klrvgicifuq7q2hdqglw'
          }
        }
      end
      let(:error_response) do
        {
          description: 'Fraud risk detected by anti-fraud system',
          http_code: '402',
          message: I18n.t('solidus_open_pay.transaction.error'),
          error_code: '3005',
          category: 'gateway'
        }
      end

      before do
        allow_any_instance_of(described_class)
            .to receive(:current_order).and_return(order)
        allow_any_instance_of(Charges)
          .to receive(:create) {
            raise OpenpayTransactionException.new(
              error_response.to_json
            )
          }
      end

      it 'returns an error' do
        post '/solidus_open_pay/payments.json', params: params

        parsed_response = JSON.parse(response.body)
        expect(parsed_response['error'])
            .to eq(I18n.t('solidus_open_pay.transaction.error'))
        expect(parsed_response['redirect_url']).not_to be_empty
      end
    end
  end
end
