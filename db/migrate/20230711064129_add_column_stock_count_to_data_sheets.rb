class AddColumnStockCountToDataSheets < ActiveRecord::Migration[7.0]
  def change
    add_column :data_sheets, :stock_count, :string
  end
end
