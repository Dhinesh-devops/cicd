class CreateDataSheets < ActiveRecord::Migration[7.0]
  def change
    create_table :data_sheets do |t|
      t.string :sheet_name
      t.integer :imported_by

      t.timestamps
    end
  end
end
