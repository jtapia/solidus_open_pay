# frozen_string_literal: true

class RenameNumberColumnToOpenPaySources < SolidusSupport::Migration[4.2]
  disable_ddl_transaction!

  def change
    add_column :open_pay_sources, :card_number, :string
    remove_column :open_pay_sources, :number, :string
  end
end
