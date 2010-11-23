class Category < ActiveRecord::Base
  has_many :poops
  validates_presence_of :name
end
