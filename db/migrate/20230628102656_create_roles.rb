class CreateRoles < ActiveRecord::Migration[7.0]
  def change
    create_table :roles do |t|
      t.string :name

      t.timestamps
    end

    add_index :roles, [:id, :name], name: 'index_roles_on_required_columns'
  end
end
