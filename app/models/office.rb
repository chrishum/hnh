class Office < ActiveRecord::Base
  attr_accessible :title, :state, :start_date, :end_date
  
  belongs_to :perp
  belongs_to :party
  
  validates :title,      :presence => true, 
                         :length   => { :maximum => 60 }
  
  validates :state,      :presence => true, 
                         :length   => { :maximum => 2 }
  
  validates :start_date, :presence => true
  
  validate :start_end_date_order

private

def start_end_date_order
  if end_date && start_date && (end_date < start_date)
    errors.add(:end_date, "must be equal to or after start date.")
  end
end
  
end
# == Schema Information
#
# Table name: offices
#
#  id         :integer         not null, primary key
#  title      :string(255)
#  state      :string(255)
#  party_id   :integer
#  start_date :date
#  end_date   :date
#  perp_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

