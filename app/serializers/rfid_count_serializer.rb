class RfidCountSerializer < ActiveModel::Serializer
  attributes :total, :with_rfid, :without_rfid

  def total
    object.stock_items.count
  end

  def with_rfid
    object.stock_items.with_rfid.count
  end

  def without_rfid
    object.stock_items.without_rfid.count
  end
end