class AddColumnSoftDeleteToDataSheets < ActiveRecord::Migration[7.0]
  def change
    add_column :data_sheets, :soft_delete, :boolean, default: false
  end
end
