# frozen_string_literal: true

Spree::Core::Engine.routes.draw do
  namespace :open_pay do
    resources :payments, only: %i[create show]
  end
end
