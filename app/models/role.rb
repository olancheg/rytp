class Role < ActiveRecord::Base
  attr_accessible :mask, :name

  LIST = { :admin => 4, :news_maker => 3, :policeman => 2, :user => 1 }

  validates_presence_of :name, :mask
  validates_numericality_of :mask

  has_many :role_associations

  def to_s
    I18n.t [:roles, LIST.key(mask)].join('.').to_sym
  end
end
