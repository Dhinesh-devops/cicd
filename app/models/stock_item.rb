class StockItem < ApplicationRecord
  belongs_to :data_sheet

  enum status: {missed: 0, scanned: 1}
end