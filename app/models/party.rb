class Party < ActiveRecord::Base
  attr_accessible :name, :three_letter, :one_letter
  
  has_many :perps
  has_many :offices

  validates :name,         :presence   => true,
                           :length     => { :maximum => 30 },
                           :uniqueness => true
  
  validates :three_letter, :presence   => true,
                           :length     => { :maximum => 3 }
  
  validates :one_letter,   :presence   => true,
                           :length     => { :is => 1 }
end
# == Schema Information
#
# Table name: parties
#
#  id           :integer         not null, primary key
#  name         :string(255)
#  three_letter :string(255)
#  one_letter   :string(255)
#  created_at   :datetime
#  updated_at   :datetime
#

