class ReportSerializer < ActiveModel::Serializer
  attributes :total, :scanned, :missed, :stock_items

  def total
    object.stock_items.count
  end

  def scanned
    object.stock_items.scanned.count
  end

  def missed
    object.stock_items.missed.count
  end

  def stock_items
    ActiveModelSerializers::SerializableResource.new(object.stock_items, each_serializer: StockItemSerializer)
  end
end