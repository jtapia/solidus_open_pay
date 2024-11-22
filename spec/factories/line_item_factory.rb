# frozen_string_literal: true

FactoryBot.modify do
  factory :line_item, class: 'Spree::LineItem' do
    price { BigDecimal('29.00') }
    currency { 'MXN' }
  end
end
