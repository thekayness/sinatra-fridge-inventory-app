class Item < ActiveRecord::Base
  extend Slugify::ClassMethod
  include Slugify::InstanceMethod

  has_many :user_items
  has_many :users, through: :user_items
end
