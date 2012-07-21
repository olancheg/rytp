class ChangeApprovedToBannedInPoops < ActiveRecord::Migration
  def self.up
    change_column :poops, :approved, :boolean, :default => true
  end

  def self.down
    change_column :poops, :approved, :boolean, :default => false
  end
end
