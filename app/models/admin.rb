class Admin < ActiveRecord::Base
  validates_presence_of :login, :password, :name
  validates_uniqueness_of :login

  attr_protected :main
end
