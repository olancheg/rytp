class AlterNewsTable < ActiveRecord::Migration
  def self.up
    remove_column :news, :photo
    add_column :news, :user_id, :integer
    add_index :news, :user_id
  end

  def self.down
    add_column :news, :photo, :string
    remove_index :news, :user_id
    remove_column :news, :user_id
  end
end
