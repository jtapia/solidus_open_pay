# frozen_string_literal: true

module Decorators
  module Spree
    module LineItem
      def to_conekta
        {
          'name'        => variant.name,
          'description' => variant.description,
          'sku'         => variant.sku,
          'unit_price'  => variant.price.to_s,
          'quantity'    => quantity
        }
      end

      Spree::LineItem.prepend(self)
    end
  end
end
