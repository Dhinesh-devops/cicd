class DataSheet < ApplicationRecord
  has_many :stock_items, dependent: :destroy
  has_one_attached :file
  # before_save: daily_sheet_uploaded?

  def self.daily_sheet_uploaded?
    self.where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day).present? ? true : false
  end

  def file_path
    ActiveStorage::Blob.service.path_for(file.key)
  end

  def self.to_report_csv(data_sheet_id)
    attributes = %w{plant plant2 plant3 retek_class retek_subclass season ean_number variant_size style_code st_loc variant mrp soh_blocked_stock soh_without_blocked_stock soh_quantity soh_value}
    headers = ['Plant', 'Plant2', 'Plant3', 'Retek Class', 'Retek Subclass', 'Season', 'EAN', 'Size', 'Style Code', 'St.loc', 'Variant', 'MRP', 'SOH blocked stock', 'SOH without blocked stock', 'SOH Qty.', 'Value']
    stock_items = StockItem.where(data_sheet_id: data_sheet_id)

    CSV.generate(headers: true) do |csv|
      csv << ["Total", stock_items.count]
      csv << ["Scanned", stock_items.where(status: "scanned").count]
      csv << ["Missed", stock_items.count - stock_items.where(status: "scanned").count]
      csv << []
      csv << headers
      stock_items.each do |stock_item|
        csv << attributes.map{ |attr| stock_item.send(attr) }
      end
    end
  end

  def self.cal_percent(total, stock_count)
    return (stock_count.to_f / total.to_f) * 100
  end

  def self.is_valid?(file_path)
    valid_headers = ["Plant", "Retek Group", "Retek Dept.", "Retek Class", "Retek Subclass", "Season", "EAN", "Size", "Sleeve", "Style Code", "St.Loc", "Variant", "MRP", "SOH blocked stock", "SOH without Blocked Stk", "SOH Qty.", "Value"]
    xlsx = Roo::Spreadsheet.open(file_path, extension: :xlsx)
    binding.pry
    if xlsx
      xlsx_headers = xlsx.row(1)
      invalid_headers = (valid_headers - xlsx_headers)
      if invalid_headers.present?
        return false
      else
        return true
      end
    else
      return true
    end
  end
end