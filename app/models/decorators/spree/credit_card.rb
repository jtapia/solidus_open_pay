# frozen_string_literal: true

module Decorators
  module Spree
    module CreditCard
      def self.prepended(base)
        base.attr_accessor :name_on_card, :conekta_response

        unless Rails::VERSION::MAJOR == 4
          base.attr_accessible :name_on_card, :installments_number, :conekta_response
        end
      end

      Spree::CreditCard.prepend(self)
    end
  end
end
