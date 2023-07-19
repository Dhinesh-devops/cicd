class StockItem < ApplicationRecord
  belongs_to :data_sheet

  scope :scanned, -> { where(status: 1) }
  scope :missed, -> { where(status: nil) }
  scope :sold, -> { where(status: 2) }
  scope :with_rfid, -> { where.not(rfid_number: [nil, '']) }
  scope :without_rfid, -> { where(rfid_number: [nil, '']) }
  scope :last_week, -> { where(updated_at: (Date.today - 7.days).beginning_of_day..Date.today.end_of_day) }

  enum status: {scanned: 1, sold: 2}

  def self.get_chart_data(scanned_count, missed_count, sold_count)
    autumn_seasons = StockItem.scanned.where("season LIKE ?", "%Autumn Winter%").pluck(:season).uniq
    autumn_with_count = autumn_seasons.map { |season| StockItem.scanned.where(season: season).size }

    spring_seasons = StockItem.scanned.where("season LIKE ?", "%Spring Summer%").pluck(:season).uniq
    spring_with_count = spring_seasons.map { |season| StockItem.scanned.where(season: season).size }

    sizes = StockItem.scanned.pluck(:variant_size).uniq
    size_count = sizes.map { |size| StockItem.scanned.where(variant_size: size).size }

    sold_dates = StockItem.last_week.sold.pluck("date(stock_items.updated_at)").uniq
    sold_format_dates = sold_dates.map { |sold_date| sold_date.strftime('%d-%m-%Y') }
    sold_date_wise_count = sold_dates.map { |sold_date| StockItem.sold.where(:updated_at => sold_date.to_date.beginning_of_day..sold_date.to_date.end_of_day).size }

    retek_subclasses = StockItem.pluck(:retek_subclass).uniq.sort
    retek_subclass_count = retek_subclasses.map { |retek_subclass| StockItem.scanned.where(retek_subclass: retek_subclass).size }

    {:autumn_seasons => autumn_seasons, :autumn_with_count => autumn_with_count, :spring_seasons => spring_seasons, :spring_with_count => spring_with_count, :sizes => sizes, :size_count => size_count, :scanned_count => scanned_count, :missed_count => missed_count, :sold_count => sold_count, :sold_dates => sold_format_dates, :sold_date_wise_count => sold_date_wise_count, :retek_subclasses => retek_subclasses, :retek_subclass_count => retek_subclass_count }
  end
end