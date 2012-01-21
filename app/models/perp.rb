class Perp < ActiveRecord::Base
  attr_accessible :first_name, :last_name
  
  belongs_to :party
  has_many   :statements, :dependent => :destroy
  has_many   :offices,    :dependent => :destroy

  delegate :name, 
           :three_letter, 
           :one_letter, 
           :to => :party, 
           :prefix => true

  validates :first_name, :presence => true, 
                         :length   => { :maximum => 25 }
  validates :last_name,  :presence => true, 
                         :length   => { :maximum => 25 }
  validates :party_id,   :presence => true
  
  def full_name
    "#{first_name} #{last_name}"
  end
end
# == Schema Information
#
# Table name: perps
#
#  id         :integer         not null, primary key
#  first_name :string(255)
#  last_name  :string(255)
#  created_at :datetime
#  updated_at :datetime
#  party_id   :integer
#

