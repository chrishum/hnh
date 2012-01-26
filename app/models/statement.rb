class Statement < ActiveRecord::Base
  attr_accessible :content, :primary_source, :date, :context, :why_hypocritical, :why_hypothetical
  
  belongs_to :perp, :counter_cache => true
  
  delegate :party, 
           :party_name, 
           :party_three_letter, 
           :party_one_letter, 
           :to => :perp
  
  validates :content, :presence => true, 
                      :length => { :maximum => 140 }
  validates :perp_id, :presence => true
  validates :context, :presence => true, 
                      :length   => { :maximum => 250 }
  
  default_scope :order => 'statements.date desc'
  scope :recent, order("statements.date desc")
  scope :top,    lambda{|l| limit(l)}
  
  def self.find_top_recent_statements(limit = 10)
    recent.top(limit)
  end
  
  def perp_name
    perp.full_name
  end
end
# == Schema Information
#
# Table name: statements
#
#  id               :integer         not null, primary key
#  content          :string(255)
#  perp_id          :integer
#  date             :date
#  primary_source   :string(255)
#  context          :text
#  why_hypocritical :text
#  created_at       :datetime
#  updated_at       :datetime
#  why_hypothetical :text
#

