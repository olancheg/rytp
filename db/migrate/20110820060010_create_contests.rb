class CreateContests < ActiveRecord::Migration
  def self.up
    create_table :contests do |t|
      t.string :name
      t.string :description
      t.date :start_at
      t.date :end_at
      t.integer :first_place
      t.integer :second_place
      t.integer :third_place

      t.timestamps
    end
  end

  def self.down
    drop_table :contests
  end
end
