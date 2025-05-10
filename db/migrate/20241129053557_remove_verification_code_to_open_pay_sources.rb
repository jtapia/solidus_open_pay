# frozen_string_literal: true

class RemoveVerificationCodeToOpenPaySources < SolidusSupport::Migration[4.2]
  disable_ddl_transaction!

  def change
    remove_column :open_pay_sources, :verification_value, :string
  end
end
