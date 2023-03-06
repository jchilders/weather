# frozen_string_literal: true

class CreateForecasts < ActiveRecord::Migration[7.0]
  def change
    create_table(:forecasts) do |t|
      t.references(:address)
      t.jsonb(:response)

      t.timestamps
    end
  end
end
