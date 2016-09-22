class User < ActiveRecord::Base
  extend Slugify::ClassMethod
  include Slugify::InstanceMethod
  
  has_many :items

  has_secure_password
end
