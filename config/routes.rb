# frozen_string_literal: true

Spree::Core::Engine.routes.draw do
  namespace :open_pay do
    resources :payments, only: [:create, :show]
  end
end
