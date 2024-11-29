# frozen_string_literal: true

class RenameNumberColumnToOpenPaySources < SolidusSupport::Migration[4.2]
  disable_ddl_transaction!

  def change
    rename_column :open_pay_sources, :number, :card_number
  end
end
