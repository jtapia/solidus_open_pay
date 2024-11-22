# frozen_string_literal: true

class CreateSpreeOpenPayPayments < ActiveRecord::Migration[7.1]
  def change
    create_table :spree_open_pay_payments do |t|
      t.string :type

      t.timestamps
    end
  end
end
