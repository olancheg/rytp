class AddColumnsToPoop < ActiveRecord::Migration
  def self.up
    add_column :poops, :rate, :integer
    add_column :poops, :category_id, :integer
  end

  def self.down
    remove_column :poops, :category_id
    remove_column :poops, :rate
  end
end
