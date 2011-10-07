class Group < ActiveRecord::Base
  # belongs_to :owner, :class_name => :user, :foreign_key => :owner_id
  # has_one :user, :as => :owner
  has_many :memberships
  has_many :users, :through => :memberships 
  # has_one :owner, :foreign_key => 'owner_id'
end