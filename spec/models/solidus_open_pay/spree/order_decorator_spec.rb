# frozen_string_literal: true

require 'spec_helper'

# rubocop:disable Style/HashSyntax
RSpec.describe SolidusOpenPay::Spree::OrderDecorator, type: :model do
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
      payment_method: open_pay_payment_method,
      redirect_url: 'localhost:3000/redirect'
    )
  end
  let!(:order) do
    create(
      :order_with_line_items,
      user: user,
      ship_address: address,
      bill_address: address
    )
  end
  let!(:payment) do
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

  describe '.open_pay_payments?' do
    context 'with payments' do
      it 'returns the available open pay payments' do
        expect(order.open_pay_payments?).to be_truthy
      end
    end

    context 'without payments' do
      before do
        order.payments = []
      end

      it 'returns the available open pay payments' do
        expect(order.open_pay_payments?).to be_falsey
      end
    end
  end

  describe '.open_pay_payments' do
    context 'with payments' do
      it 'returns the available open pay payments' do
        expect(order.open_pay_payments).to include(payment)
      end
    end

    context 'without payments' do
      before do
        order.payments = []
      end

      it 'returns the available open pay payments' do
        expect(order.open_pay_payments).to be_empty
      end
    end
  end

  describe '.current_open_pay_payment' do
    context 'with payments' do
      it 'returns the available open pay payments' do
        expect(order.current_open_pay_payment).to eq(payment)
      end
    end

    context 'without payments' do
      before do
        order.payments = []
      end

      it 'returns the available open pay payments' do
        expect(order.open_pay_payments).to be_empty
      end
    end
  end

  describe '.current_open_pay_payment_redirect_url' do
    context 'with payments' do
      it 'returns the available open pay payments' do
        expect(order.current_open_pay_payment_redirect_url)
            .to eq('localhost:3000/redirect')
      end
    end

    context 'without payments' do
      before do
        order.payments = []
      end

      it 'returns the available open pay payments' do
        expect(order.current_open_pay_payment_redirect_url)
            .to be_nil
      end
    end
  end
end
# rubocop:enable Style/HashSyntax
