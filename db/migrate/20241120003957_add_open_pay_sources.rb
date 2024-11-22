# frozen_string_literal: true

class AddOpenPaySources < ActiveRecord::Migration[7.1]
  def change
    create_table :open_pay_sources do |t|
      t.integer :payment_method_id
      t.string :authorization_id
      t.string :capture_id
      t.string :name
      t.string :device_session_id
      t.string :verification_value
      t.string :token_id
      t.string :number
      t.integer :expiration_month
      t.integer :expiration_year
      t.string :brand
      t.boolean :points_card, default: false
      t.string :points_type

      t.timestamps
    end
  end
end
