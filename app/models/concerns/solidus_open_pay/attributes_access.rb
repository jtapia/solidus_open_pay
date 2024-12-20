# frozen_string_literal: true

module SolidusOpenPay
  module AttributesAccess
    extend ActiveSupport::Concern

    included do
      attr_accessor :brand,
                    :device_session_id,
                    :expiration_month,
                    :expiration_year,
                    :number,
                    :token_id,
                    :verification_value,
                    :points_card,
                    :points_type

      def brand=(value)
        self[:brand] = value.to_s.gsub(/\s/, '')
      end

      def device_session_id=(value)
        self[:device_session_id] = value.to_s.gsub(/\s/, '')
      end

      def number=(value)
        number_value =
          if value.is_a?(String)
            value.gsub(/[^0-9]/, '')
          end

        self[:number] = if number_value.to_s.length <= 4
          number_value
        else
          number_value.to_s.last(4)
        end
      end

      def token_id=(value)
        self[:token_id] = value.to_s.gsub(/\s/, '')
      end

      def points_card=(value)
        self[:points_card] = value.to_s.gsub(/\s/, '')
      end

      def points_type=(value)
        self[:points_type] = value.to_s.gsub(/\s/, '')
      end

      def expiration_month=(value)
        self[:expiration_month] = value.to_i if value
      end

      def expiration_year=(value)
        if value
          self[:expiration_year] = "20#{value}" if value.length == 2
          self[:expiration_year] = value.to_i
        end
      end

      def brand
        self[:brand]
      end

      def device_session_id
        self[:device_session_id]
      end

      def number
        self[:number]
      end

      def token_id
        self[:token_id]
      end

      def display_number
        "XXXX-XXXX-XXXX-#{number}"
      end
    end
  end
end
