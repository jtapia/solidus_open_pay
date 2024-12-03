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
        payload = build_base_payload
        payload = include_secure_3d(payload) if secure_3d?

        payload
      end

      private

      def payment_method
        @payment_method ||= source.payment_method
      end

      def token_id
        @token_id ||= source.token_id
      end

      def email
        @email ||= order&.email || 'pedidos@donmanolito.com'
      end

      def capture
        @capture ||= payment_method.auto_capture || false
      end

      def order_id
        @order_id ||= options[:order_id]
      end

      def order
        @order ||= ::Spree::Order.find_by(
          number: order_id.split('-')[0]
        )
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

      def secure_3d
        @secure_3d ||=
          payment_method.preferred_secure_3d || false
      end

      def secure_3d?
        secure_3d == true
      end

      def redirect_url
        @redirect_url ||= payment_method.preferred_redirect_url ||
          "#{order.store.url}/checkout/confirm"
      end

      def include_secure_3d(payload)
        payload.merge({
          'use_3d_secure' => secure_3d,
          'redirect_url' => redirect_url
        })
      end

      def build_base_payload
        {
          'source_id' => token_id,
          'method' => 'card',
          'amount' => amount / 100,
          'currency' => 'MXN',
          'capture' => capture,
          'description' => 'Cargo inicial',
          'order_id' => order_id,
          'device_session_id' => device_session_id,
          'customer' => {
            'name' => first_name,
            'last_name' => last_name,
            'phone_number' => phone_number,
            'email' => email
          }
        }
      end
    end
  end
end
