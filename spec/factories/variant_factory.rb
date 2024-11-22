# frozen_string_literal: true

FactoryBot.modify do
  factory :base_variant, class: 'Spree::Variant' do
    currency { 'MXN' }
    cost_currency { 'MXN' }
  end
end
