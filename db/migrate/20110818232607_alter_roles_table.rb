class AlterRolesTable < ActiveRecord::Migration
  def self.up
    remove_index :roles, :user_id
    remove_column :roles, :user_id

    add_column :roles, :name, :string, :null => false
    add_index :roles, :name
  end

  def self.down
    remove_index :roles, :name
    remove_column :roles, :name

    add_column :roles, :user_id, :integer
    add_index :roles, :user_id
  end
end
