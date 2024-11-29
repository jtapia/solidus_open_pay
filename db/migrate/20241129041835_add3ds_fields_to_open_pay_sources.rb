# frozen_string_literal: true

class Add3dsFieldsToOpenPaySources < SolidusSupport::Migration[4.2]
  disable_ddl_transaction!

  def change
    add_column :open_pay_sources, :redirect_url, :string
    add_column :open_pay_sources, :card_type, :string

    rename_column :open_pay_sources, :number, :card_number
    rename_column :open_pay_sources, :name, :holder_name

    remove_column :open_pay_sources, :verification_value
  end
end
