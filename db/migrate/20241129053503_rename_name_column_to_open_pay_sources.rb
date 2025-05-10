# frozen_string_literal: true

class RenameNameColumnToOpenPaySources < SolidusSupport::Migration[4.2]
  disable_ddl_transaction!

  def change
    add_column :open_pay_sources, :holder_name, :string
    remove_column :open_pay_sources, :name, :string
  end
end
