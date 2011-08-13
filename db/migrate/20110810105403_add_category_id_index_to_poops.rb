class AddCategoryIdIndexToPoops < ActiveRecord::Migration
  def self.up
    add_index :poops, :category_id
  end

  def self.down
    remove_index :poops, :category_id
  end
end
