class Api::V1::SoldItemsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def update_sold_items
    errors = []
    tag_reads = params[:tag_reads] if params[:tag_reads].present?
    tag_reads.present? && tag_reads.each do | tag_read |
      stock_item = StockItem.find_by(rfid_number: tag_read[:epc])
      if stock_item.present?
        stock_item.update!(status: 2) if (stock_item.status != "sold")
      else
        errors << tag_read[:epc]
      end
    end
    if errors.present?
      response_failure('Stock is not present with these RFID numbers ' + errors.uniq.to_sentence, 409)
    else
      response_success('Updated sold items successfully.', 200)
    end
  rescue Exception => e
    response_failure(e, 500)
  end
end