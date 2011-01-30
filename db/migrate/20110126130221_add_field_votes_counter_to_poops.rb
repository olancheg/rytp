class AddFieldVotesCounterToPoops < ActiveRecord::Migration
  def self.up
    add_column :poops, :votes_count, :integer
  end

  def self.down
    remove_column :poops, :votes_count
  end
end
