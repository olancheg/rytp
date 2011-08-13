class CreateVotes < ActiveRecord::Migration
  def self.up
    create_table :votes do |t|
      t.boolean :positive, :null => false
      t.references :user
      t.references :poop

      t.timestamps
    end

    add_index :votes, :user_id
    add_index :votes, :poop_id
  end

  def self.down
    drop_table :votes
  end
end
