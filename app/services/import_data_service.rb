class ImportDataService

  def initialize(xlsx_path, data_sheet_id)
    @xlsx_path = xlsx_path
    @data_sheet_id = data_sheet_id
  end

  def process
    xlsx = Roo::Spreadsheet.open(@xlsx_path, extension: :xlsx)
    if xlsx
      xlsx.sheet(0).each_with_index(plant: 'Plant', plant2: 'Retek Group', plant3: 'Retek Dept.', retek_class: 'Retek Class', retek_subclass: 'Retek Subclass', season: 'Season', ean_number: 'EAN', variant_size: 'Size', style_code: 'Style Code', st_loc: 'St.Loc', variant: 'Variant', mrp: 'MRP', soh_blocked_stock: 'SOH blocked stock', soh_without_blocked_stock: 'SOH without Blocked Stk', soh_quantity: 'SOH Qty.', soh_value: 'Value', rfid_number: 'RFID Number') do |row, row_index|
        next if row_index == 0

        # stock_item_exist = check_stock_item(row)
        # create_stock_items(row) unless stock_item_exist
        create_stock_items(row)
      end
      StockItem.update_all(data_sheet_id: @data_sheet_id, soft_delete: false)
      data_sheet = DataSheet.find_by(id: @data_sheet_id)
      data_sheet.update(stock_count: data_sheet.stock_items.count)
    end
  end

  def create_stock_items(row)
    stock_item_exist = check_stock_item_with_rfid(row)
    StockItem.create(
      data_sheet_id: @data_sheet_id,
      plant: cell_format(row[:plant]).to_i,
      plant2: cell_format(row[:plant2]),
      plant3: cell_format(row[:plant3]),
      retek_class: cell_format(row[:retek_class]),
      retek_subclass: cell_format(row[:retek_subclass]),
      season: cell_format(row[:season]),
      ean_number: cell_format(row[:ean_number]).to_i,
      variant_size: cell_format(row[:variant_size]).to_i,
      style_code: cell_format(row[:style_code]),
      st_loc: cell_format(row[:st_loc]).to_i,
      variant: cell_format(row[:variant]),
      mrp: cell_format(row[:mrp]).to_i,
      soh_blocked_stock: cell_format(row[:soh_blocked_stock]).to_i,
      soh_without_blocked_stock: cell_format(row[:soh_without_blocked_stock]).to_i,
      soh_quantity: cell_format(row[:soh_quantity]).to_i,
      soh_value: cell_format(row[:soh_value]).to_i,
      rfid_number: stock_item_exist ? "" : cell_format(row[:rfid_number])
    )
  end

  def check_stock_item(row)
    stock_item = StockItem.find_by(ean_number: cell_format(row[:ean_number]).to_i)
    return stock_item.present?
  end

  def check_stock_item_with_rfid(row)
    stock_item = StockItem.find_by(rfid_number: cell_format(row[:rfid_number]))
    return stock_item.present?
  end

  def cell_format(data)
    return data.to_s.strip
  end
end