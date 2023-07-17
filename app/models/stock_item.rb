class StockItem < ApplicationRecord
  belongs_to :data_sheet

  scope :scanned, -> { where(status: 1) }
  scope :missed, -> { where(status: nil) }
  scope :sold, -> { where(status: 2) }
  scope :with_rfid, -> { where.not(rfid_number: [nil, '']) }
  scope :without_rfid, -> { where(rfid_number: [nil, '']) }

  enum status: {scanned: 1, sold: 2}
end