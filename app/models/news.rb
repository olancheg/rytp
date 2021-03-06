class News < ActiveRecord::Base
  attr_accessible :title, :content

  PAGINATES_PER = 5

  belongs_to :user

  validates_presence_of :title, :content

  scope :ordered, order('created_at DESC')
  scope :back_ordered, order('created_at ASC')

  paginates_per PAGINATES_PER

  def self.fetch_last
    ordered.limit(1).first
  end

  def to_param
    "#{id}-#{title.parameterize}"
  end
end
