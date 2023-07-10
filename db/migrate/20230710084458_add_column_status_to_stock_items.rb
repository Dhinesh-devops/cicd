class AddColumnStatusToStockItems < ActiveRecord::Migration[7.0]
  def change
    add_column :stock_items, :status, :integer
  end
end
