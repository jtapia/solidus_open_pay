# frozen_string_literal: true

class RenameNameColumnToOpenPaySources < SolidusSupport::Migration[4.2]
  disable_ddl_transaction!

  def change
    rename_column :open_pay_sources, :name, :holder_name
  end
end
