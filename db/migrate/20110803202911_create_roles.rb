class CreateRoles < ActiveRecord::Migration
  def self.up
    create_table :roles do |t|
      t.string :name, :null => false
      t.integer :mask, :default => 0, :null => false
      t.references :user

      t.timestamps
    end

    add_index :roles, :user_id
  end

  def self.down
    drop_table :roles
  end
end
