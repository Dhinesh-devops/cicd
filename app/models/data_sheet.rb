class DataSheet < ApplicationRecord
  has_many :stock_items
  has_one_attached :file
  # before_save: daily_sheet_uploaded?

  scope :active, -> { where(soft_delete: false) }

  def self.daily_sheet_uploaded?
    self.where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day).present? ? true : false
  end

  def file_path
    ActiveStorage::Blob.service.path_for(file.key)
  end

  def self.to_report_csv(params)
    attributes = %w{plant plant2 plant3 retek_class retek_subclass season ean_number rfid_number variant_size style_code st_loc variant mrp soh_blocked_stock soh_without_blocked_stock soh_quantity soh_value status}
    headers = ['Plant', "Retek Group", "Retek Dept.", 'Retek Class', 'Retek Subclass', 'Season', 'EAN', 'RFID Number', 'Size', 'Style Code', 'St.loc', 'Variant', 'MRP', 'SOH blocked stock', 'SOH without blocked stock', 'SOH Qty.', 'Value', 'Status']
    stock_items = self.get_stock_items(params)

    CSV.generate(headers: true) do |csv|
      csv << ["Total", stock_items.count]
      csv << ["Stock", stock_items.scanned.count]
      csv << ["Missed", stock_items.count - (stock_items.scanned.count + stock_items.sold.count)]
      csv << ["Sold", stock_items.sold.count]
      csv << []
      csv << headers
      stock_items.each do |stock_item|
        csv << attributes.map{ |attr| (attr == "status") && (stock_item.status == nil) ? 'missed' : ((attr == "status") && (stock_item.status == 'scanned') ? 'stock' : stock_item.send(attr)) }
      end
    end
  end

  def self.cal_percent(total, stock_count)
    return (stock_count.to_f / total.to_f) * 100
  end

  def self.is_valid?(file_path)
    valid_headers = ["Plant", "Retek Group", "Retek Dept.", "Retek Class", "Retek Subclass", "Season", "EAN", "Size", "Sleeve", "Style Code", "St.Loc", "Variant", "MRP", "SOH blocked stock", "SOH without Blocked Stk", "SOH Qty.", "Value", "RFID Number"]
    xlsx = Roo::Spreadsheet.open(file_path, extension: :xlsx)
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

  def category_wise_stocks(category)
    if (category == "scanned")
      self.stock_items.scanned
    elsif (category == "missed")
      self.stock_items.missed
    elsif (category == "sold")
      self.stock_items.sold
    end
  end

  def date_wise_stocks(start_date, end_date)
    start_date = start_date.to_date.beginning_of_day
    end_date = end_date.to_date.end_of_day
    self.stock_items.where(:created_at => start_date..end_date)
  end

  def filter_wise_stocks(category, start_date, end_date)
    start_date = start_date.to_date.beginning_of_day
    end_date = end_date.to_date.end_of_day
    if (category == "scanned")
      self.stock_items.scanned.where(:created_at => start_date..end_date)
    elsif (category == "missed")
      self.stock_items.missed.where(:created_at => start_date..end_date)
    elsif (category == "sold")
      self.stock_items.sold.where(:created_at => start_date..end_date)
    end
  end

  def self.get_stock_items(params)
    data_sheet = DataSheet.last
    if params[:category].present? && params[:start_date].present? && params[:end_date].present?
      stock_items = data_sheet.filter_wise_stocks(params[:category], params[:start_date], params[:end_date])
    elsif params[:category].present?
      stock_items = data_sheet.category_wise_stocks(params[:category])
    elsif params[:start_date].present? && params[:end_date].present?
      stock_items = data_sheet.date_wise_stocks(params[:start_date], params[:end_date])
    else
      stock_items = data_sheet.stock_items
    end
  end
end