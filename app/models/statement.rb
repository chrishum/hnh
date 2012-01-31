class Statement < ActiveRecord::Base
  attr_accessible :content, :primary_source, :date, :context, :why_hypocritical, :why_hypothetical, :hypocrisy_score
  
  belongs_to :perp, :counter_cache => true
  has_many :hypocrisy_ratings
  has_many :hyperbole_ratings
  
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
  
  def perp_thumb_url
    perp.thumb_url
  end
    
  def calculate_hypocrisy_score
    reload
    if hypocrisy_ratings_count > 4
      self.hypocrisy_score = hypocrisy_ratings.average(:rating).to_i
      save!
      calculate_score
    end
  end
  
  def calculate_hyperbole_score
    reload
    if hyperbole_ratings_count > 4
      self.hyperbole_score = hyperbole_ratings.average(:rating).to_i
      save!
      calculate_score
    end
  end
  
  private

    def calculate_score
      reload
      if !hypocrisy_score.nil? && !hyperbole_score.nil? 
        self.score = ((hypocrisy_score + hyperbole_score) / 2).to_i
        save!
      end
    end
end
# == Schema Information
#
# Table name: statements
#
#  id                      :integer         not null, primary key
#  content                 :string(255)
#  perp_id                 :integer
#  date                    :date
#  primary_source          :string(255)
#  context                 :text
#  why_hypocritical        :text
#  created_at              :datetime
#  updated_at              :datetime
#  why_hyperbolical        :text
#  hypocricy_score         :integer
#  hyperbole_score         :integer
#  score                   :integer
#  hypocrisy_ratings_count :integer         default(0)
#  hyperbole_ratings_count :integer         default(0)
#

