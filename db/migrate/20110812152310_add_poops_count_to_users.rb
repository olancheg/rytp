class AddPoopsCountToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :poops_count, :integer, :default => 0
  end

  def self.down
    remove_column :users, :poops_count
  end
end
