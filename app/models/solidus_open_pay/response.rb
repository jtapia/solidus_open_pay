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
        I18n.t('solidus_open_pay.transaction.error')
      end
    end
  end
end
