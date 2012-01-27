class Perp < ActiveRecord::Base
  attr_accessible :first_name, :middle_name, :last_name, :name_suffix, :bioguide_id
  
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
  
  scope :trending, order("statements_count desc")
  scope :top,      lambda {|l| limit(l)}
  
  def self.find_top_trending_perps(limit = 5)
    trending.top(limit)
  end
  
  def full_name
    "#{first_name} #{last_name}"
  end
  
  def thumb_url
    "perps/100x125/#{bioguide_id}.jpg"
  end
end
# == Schema Information
#
# Table name: perps
#
#  id               :integer         not null, primary key
#  first_name       :string(255)
#  last_name        :string(255)
#  party_id         :integer
#  created_at       :datetime
#  updated_at       :datetime
#  statements_count :integer         default(0)
#  middle_name      :string(255)     default("")
#  name_suffix      :string(255)     default("")
#  bioguide_id      :string(255)
#

