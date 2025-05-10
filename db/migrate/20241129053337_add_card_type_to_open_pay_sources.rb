# frozen_string_literal: true

class AddCardTypeToOpenPaySources < SolidusSupport::Migration[4.2]
  def change
    add_column :open_pay_sources, :card_type, :string
  end
end
