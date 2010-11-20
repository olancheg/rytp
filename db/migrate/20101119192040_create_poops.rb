class CreatePoops < ActiveRecord::Migration
  def self.up
    create_table :poops do |t|
      t.string :title
      t.text :description
      t.string :author
      t.text :code
      t.boolean :is_approved, :default => false

      t.timestamps
    end
  end

  def self.down
    drop_table :poops
  end
end
