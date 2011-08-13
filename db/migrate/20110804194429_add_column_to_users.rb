class AddColumnToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :votes_count, :integer, :default => 0
  end

  def self.down
    remove_column :users, :votes_count
  end
end
