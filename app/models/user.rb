require 'digest'
class User < ActiveRecord::Base
  acts_as_authentic do |c|
    c.merge_validates_length_of_password_field_options({ :minimum => 6 })
  end
    
  attr_accessible :handle, :email, :password, :password_confirmation
  
  has_many :hypocrisy_ratings
  has_many :hyperbole_ratings
  
  validates :handle, :presence        => true, 
                     :length          => { :maximum => 50 }
end
# == Schema Information
#
# Table name: users
#
#  id                :integer         not null, primary key
#  handle            :string(255)
#  email             :string(255)
#  crypted_password  :string(255)
#  password_salt     :string(255)
#  persistence_token :string(255)
#  perishable_token  :string(255)
#  admin             :boolean         default(FALSE)
#  created_at        :datetime
#  updated_at        :datetime
#

