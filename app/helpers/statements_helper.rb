module StatementsHelper

  def score_value(score)
    if score.nil?
      image_tag "no_score.jpg", :alt => "Not enough ratings to score.", :class => "no_score"
    else
      score
    end
  end
  
  def score_color_class(score)
    case score
    when nil
      "none"
    when 0..33
      "low"
    when 34..66
      "mid"
    when 67..100
      "high"
    end
  end
end
