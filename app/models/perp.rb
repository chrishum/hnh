class Perp < ActiveRecord::Base
  attr_accessible :first_name, :last_name, :party
  
  validates :first_name, :presence => true, 
                         :length   => { :maximum => 25 }
  validates :last_name,  :presence => true, 
                         :length   => { :maximum => 25 }
  
end
# == Schema Information
#
# Table name: perps
#
#  id         :integer         not null, primary key
#  first_name :string(255)
#  last_name  :string(255)
#  party      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

