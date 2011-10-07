class Group < ActiveRecord::Base
  belongs_to :user
  has_many :users, :through => :memberships
end