class User < ActiveRecord::Base 
  # belongs_to :group
  has_many :memberships
  has_many :groups, :through => :memberships
end
