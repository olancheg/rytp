class ResetSomePoopRates < ActiveRecord::Migration
  def self.up
    avtoprom = Poop.find(168)
    avtoprom.rate = 324
    avtoprom.save

    usher = Poop.find(276)
    usher.rate = 80
    usher.save
  end

  def self.down
  end
end
