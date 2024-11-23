# frozen_string_literal: true

class AddOpenPayIdToSpreeUser < SolidusSupport::Migration[4.2]
  def change
    add_column :spree_users, :open_pay_id, :string
  end
end
