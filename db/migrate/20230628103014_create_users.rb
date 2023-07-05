class CreateUsers < ActiveRecord::Migration[7.0]
  create_table :users do |t|
    t.string :first_name
    t.string :last_name
    t.string :email, null: false, default: ""
    t.string :encrypted_password, null: false, default: ""
    t.references :role, null: false, foreign_key: true

    t.timestamps
  end

  add_index :users, :email, unique: true
  add_index :users, [:id, :role_id], name: 'index_users_on_id_role_id'
end
