class StockItem < ApplicationRecord
  belongs_to :data_sheet

  scope :scanned, -> { where(status: 1) }
  scope :missed, -> { where(status: 0) }
  scope :with_rfid, -> { where.not(rfid_number: nil) }
  scope :without_rfid, -> { where(rfid_number: nil) }

  enum status: {missed: 0, scanned: 1}
end