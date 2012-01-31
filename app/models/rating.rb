class Rating < ActiveRecord::Base
  attr_accessible :rating, :type

  validates :rating,       :presence => true, 
                           :inclusion => {:in => 0..100}, 
                           :numericality => {:only_integer => true}
  validates :user_id,      :presence => true
  validates :statement_id, :presence => true
#                           :uniqueness => {:scope => :user_id}
end
# == Schema Information
#
# Table name: ratings
#
#  id           :integer         not null, primary key
#  user_id      :integer
#  statement_id :integer
#  type         :string(255)
#  rating       :integer
#  created_at   :datetime
#  updated_at   :datetime
#

