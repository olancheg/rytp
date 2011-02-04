class Admin < ActiveRecord::Base
  attr_protected :main

  validates_presence_of :login, :password, :name
  validates_uniqueness_of :login
  before_validation :downcase_login

  def downcase_login
    self.login = self.login.mb_chars.downcase
  end
end
