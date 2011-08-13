class Role < ActiveRecord::Base
  attr_accessible :mask

  LIST = { :admin => 3, :news_maker => 2, :policeman => 1, :user => 0 }

  validates_numericality_of :mask

  belongs_to :user

  def to_s
    I18n.t [:roles, LIST.key(mask)].join('.').to_sym
  end
end
