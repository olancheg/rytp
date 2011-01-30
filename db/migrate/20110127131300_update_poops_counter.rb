class UpdatePoopsCounter < ActiveRecord::Migration
  def self.up
    Poop.update_all ['votes_count = ?', 0]
  end

  def self.down
  end
end
