class Vote < ActiveRecord::Base
  attr_accessible :poop, :positive

  belongs_to :user, :counter_cache => true
  belongs_to :poop, :counter_cache => true

  validates_uniqueness_of :poop_id, :scope => :user_id

  scope :positive, where(:positive => true)
  scope :negative, where(:positive => false)

  after_save :update_poop_rating, :on => :create

  def update_poop_rating
    if positive?
      poop.increment('rating').save
    else
      poop.decrement('rating').save
    end
  end
end
