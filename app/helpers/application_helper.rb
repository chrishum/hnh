module ApplicationHelper
  
  def logo
    image_tag("hnh logo.png", :alt => "Hyp & Hype", :class => "round")
  end
  
  # Return a title on a per-page basis.
  def title
    base_title = "Hyp & Hype"
    if @title.nil?
      base_title
    else
      "#{base_title} | #{@title}"
    end
  end
end
