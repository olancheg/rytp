class CreateCategories < ActiveRecord::Migration
  def self.up
    create_table :categories do |t|
      t.string :name

      t.timestamps
    end
    Category.create(:name => 'RYTP')
    Category.create(:name => 'RYTPMV')
  end

  def self.down
    drop_table :categories
  end
end
