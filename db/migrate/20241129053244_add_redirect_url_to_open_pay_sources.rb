# frozen_string_literal: true

class AddRedirectUrlToOpenPaySources < SolidusSupport::Migration[4.2]
  def change
    add_column :open_pay_sources, :redirect_url, :string
  end
end
