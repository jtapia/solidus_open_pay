# frozen_string_literal: true

FactoryBot.modify do
  factory :price, class: 'Spree::Price' do
    variant
    amount { 29.99 }
    currency { 'MXN' }
  end
end
