# frozen_string_literal: true

FactoryBot.modify do
  factory :order, class: 'Spree::Order' do
    currency { 'MXN' }
  end
end
