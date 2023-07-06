class CreateStockItems < ActiveRecord::Migration[7.0]
  def change
    create_table :stock_items do |t|
      t.integer :data_sheet_id
      t.string :plant
      t.string :plant2
      t.string :plant3
      t.string :retek_class
      t.string :retek_subclass
      t.string :season
      t.string :ean_number
      t.string :variant_size
      t.string :style_code
      t.string :st_loc
      t.string :variant
      t.string :mrp
      t.string :soh_blocked_stock
      t.string :soh_without_blocked_stock
      t.string :soh_quantity
      t.string :soh_value

      t.timestamps
    end
  end
end
