class StockItem < ApplicationRecord
  belongs_to :data_sheet

  scope :scanned, -> { where(status: 1) }
  scope :missed, -> { where(status: 0) }

  enum status: {missed: 0, scanned: 1}
end