# frozen_string_literal: true

require 'active_merchant/billing/response'

module SolidusOpenPay
  class Response < ::ActiveMerchant::Billing::Response
    class << self
      private :new

      def build(result)
        if success?(result)
          build_success(result)
        else
          build_failure(result)
        end
      end

      private

      def success?(result)
        result.try(:[], 'id').present? &&
          result.try(:[], 'error_message').blank?
      end

      def build_success(result)
        new(
          true,
          result['description'],
          result,
          authorization: result['id']
        )
      end

      def build_failure(result)
        response = JSON.parse(result.json_body)

        new(
          false,
          error_message(response),
          response,
          {}
        )
      end

      def error_message(result)
        error_message = transaction_error_message(result['error_code'])

        [
          error_message.to_s,
          "(#{result['error_code']})"
        ].join(' ')
      end

      def transaction_error_message(error_code)
        I18n.t(
          error_code,
          scope: 'solidus_open_pay.gateway_rejection_reasons',
          default: 'Error'
        )
      end
    end
  end
end
