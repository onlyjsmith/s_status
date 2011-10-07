class Membership < ActiveRecord::Base
  has_many :users
  has_one :group
end
