class AddColumnSoftDeleteToStockItems < ActiveRecord::Migration[7.0]
  def change
    add_column :stock_items, :soft_delete, :boolean, default: false
  end
end
