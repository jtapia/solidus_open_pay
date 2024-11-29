# frozen_string_literal: true

SolidusOpenPay::Engine.routes.draw do
  post :payments, to: 'payments#create'
end
