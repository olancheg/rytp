class ChangeFieldInPoops < ActiveRecord::Migration
  def self.up
    remove_column :poops, :votes_count
    add_column :poops, :votes_count, :integer, :default => 0
  end

  def self.down
    remove_column :poops, :votes_count
    add_column :poops, :votes_count, :integer
  end
end
