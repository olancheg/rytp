class Favourite < ActiveRecord::Base
  attr_accessible :poop

  belongs_to :user
  belongs_to :poop

  validates_presence_of :poop_id, :user_id
  validates_uniqueness_of :poop_id, :scope => :user_id
end
