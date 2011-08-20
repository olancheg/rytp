class AddContestIdToPoops < ActiveRecord::Migration
  def self.up
    add_column :poops, :contest_id, :integer
    add_index :poops, :contest_id
  end

  def self.down
    remove_index :poops, :contest_id
    remove_column :poops, :contest_id
  end
end
