class Statement < ActiveRecord::Base
  attr_accessible :content, :primary_source, :context, :description
  
  belongs_to :perp
  
  validates :content, :presence => true, :length => { :maximum => 140 }
  validates :perp_id, :presence => true
  
  default_scope :order => 'statements.created_at DESC'
end
# == Schema Information
#
# Table name: statements
#
#  id             :integer         not null, primary key
#  content        :string(255)
#  perp_id        :integer
#  date           :date
#  primary_source :string(255)
#  context        :text
#  description    :text
#  created_at     :datetime
#  updated_at     :datetime
#

