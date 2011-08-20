class CreateFavourites < ActiveRecord::Migration
  def self.up
    create_table :favourites do |t|
      t.references :user
      t.references :poop

      t.timestamps
    end

    add_index :favourites, :user_id
    add_index :favourites, :poop_id
  end

  def self.down
    drop_table :favourites
  end
end
