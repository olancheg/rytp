class Category < ActiveRecord::Base
  has_many :poops

  validates_presence_of :name

  def self.names
    @@names ||= Category.all.map(&:name)
  end

  def self.ids
    @@ids ||= Category.all.map(&:id)
  end
end
