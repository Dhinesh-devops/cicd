class AddRfidNumberToStockItems < ActiveRecord::Migration[7.0]
  def change
    add_column :stock_items, :rfid_number, :string
  end
end
