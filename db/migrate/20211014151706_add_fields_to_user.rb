class AddFieldsToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :role, :integer, default: 0
    add_column :users, :first_name, :string, default: ""
    add_column :users, :last_name, :string, default: ""
  end
end
