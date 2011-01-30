class News < ActiveRecord::Base
  validates_presence_of :title, :content, :photo

  scope :back_ordered, order('created_at ASC')
end
