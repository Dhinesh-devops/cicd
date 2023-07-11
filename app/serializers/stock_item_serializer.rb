class StockItemSerializer < ActiveModel::Serializer
  attributes :id, :data_sheet_id, :plant, :plant2, :plant3, :retek_class, :retek_subclass, :season, :ean_number, :variant_size, 
  :style_code, :st_loc, :variant, :mrp, :soh_blocked_stock, :soh_without_blocked_stock, :soh_quantity, :soh_value, :created_at, :updated_at, :rfid_number, :status
end