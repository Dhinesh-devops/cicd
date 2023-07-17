class RfidCountSerializer < ActiveModel::Serializer
  attributes :total, :with_rfid, :without_rfid, :existed_rfids

  def total
    object.stock_items.count
  end

  def with_rfid
    object.stock_items.with_rfid.count
  end

  def without_rfid
    object.stock_items.without_rfid.count
  end

  def existed_rfids
    @instance_options[:rfid_existed_values].uniq.to_sentence
  end
end