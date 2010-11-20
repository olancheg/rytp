class ChangeRateFieldInPoops < ActiveRecord::Migration
  def self.up
    remove_column :poops, :rate
    add_column :poops, :rate, :integer, :default => 0
  end

  def self.down
    remove_column :poops, :rate
    add_column :poops, :rate, :integer
  end
end
