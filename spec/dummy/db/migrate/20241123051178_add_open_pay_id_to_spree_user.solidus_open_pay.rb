# frozen_string_literal: true

# This migration comes from solidus_open_pay (originally 20241119003957)
class AddOpenPayIdToSpreeUser < ActiveRecord::Migration[7.1]
  def change
    add_column :spree_users, :open_pay_id, :string
  end
end
