# frozen_string_literal: true

class CreateSpreeOpenPayPayments < SolidusSupport::Migration[4.2]
  def change
    create_table :spree_open_pay_payments do |t|
      t.string :type

      t.timestamps
    end
  end
end
