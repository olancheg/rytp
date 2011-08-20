class RoleAssociation < ActiveRecord::Base
  attr_accessible :user_id, :role_id

  belongs_to :user
  belongs_to :role

  validates_uniqueness_of :user_id, :scope => :role_id
end
