class DataSheet < ApplicationRecord
  has_many :stock_items
  has_one_attached :file
  # before_save: daily_sheet_uploaded?

  def self.daily_sheet_uploaded?
    self.where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day).present? ? true : false
  end

  def file_path
    ActiveStorage::Blob.service.path_for(file.key)
  end
end