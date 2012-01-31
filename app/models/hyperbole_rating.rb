class HyperboleRating < Rating
  belongs_to :user,      :counter_cache => true
  belongs_to :statement, :counter_cache => true

  validates :statement_id, :uniqueness => {:scope => :user_id}

  after_save :update_statement_scores
  
  private
  
  def update_statement_scores
    statement.calculate_hyperbole_score
  end  
end