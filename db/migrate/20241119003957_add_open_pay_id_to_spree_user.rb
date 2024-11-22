# frozen_string_literal: true

class AddOpenPayIdToSpreeUser < ActiveRecord::Migration[7.1]
  def change
    add_column :spree_users, :open_pay_id, :string
  end
end
