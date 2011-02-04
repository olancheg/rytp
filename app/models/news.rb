class News < ActiveRecord::Base
  validates_presence_of :title, :content
  validates_presence_of :photo, :message => I18n.t(:photo_validation)

  scope :back_ordered, order('created_at ASC')
end
