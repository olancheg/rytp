class ApproveAllPoops < ActiveRecord::Migration
  def self.up
    Poop.update_all ['is_approved = ?', true]
  end

  def self.down
  end
end
