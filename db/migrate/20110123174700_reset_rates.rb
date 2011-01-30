class ResetRates < ActiveRecord::Migration
  def self.up
    Poop.update_all 'rate=0'
  end

  def self.down
  end
end
