# frozen_string_literal: true

module SolidusOpenPay
  module Builders
    class Charge
      attr_reader :source, :amount, :options

      def initialize(source:, amount:, options: {})
        @source = source
        @amount = amount
        @options = options
      end

      def payload
        {
          'source_id' => token_id,
          'method' => 'card',
          'amount' => amount / 100,
          'currency' => 'MXN',
          'capture' => capture,
          'description' => 'Cargo inicial',
          'order_id' => order_id,
          'device_session_id' => device_session_id,
          'use_3d_secure' => true,
          'redirect_url' => redirect_url,
          'customer' => {
            'name' => first_name,
            'last_name' => last_name,
            'phone_number' => phone_number,
            'email' => email
          }
        }
      end

      private

      def token_id
        @token_id ||= source.token_id
      end

      def email
        @email ||= order&.email || 'pedidos@donmanolito.com'
      end

      def capture
        @capture ||= options[:capture] || false
      end

      def order_id
        @order_id ||= options[:order_id]
      end

      def order
        @order ||= ::Spree::Order.find_by(number: order_id.split('-')[0])
      end

      def phone_number
        @phone_number ||= order&.bill_address&.phone
      end

      def device_session_id
        @device_session_id ||= source.device_session_id
      end

      def first_name
        @first_name ||= source.name.split[0]
      end

      def last_name
        @last_name ||= source.name.split[1]
      end

      def redirect_url
        @redirect_url ||= [
          order.store.url,
          'orders',
          order.number
        ].join('/')
      end
    end
  end
end
