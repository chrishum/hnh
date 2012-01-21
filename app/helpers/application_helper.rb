module ApplicationHelper
  
  def logo
    image_tag("hnh_logo.png", :alt => "Hyp & Hype", :class => "round")
  end
  
  # Return a title on a per-page basis.
  def title
    base_title = "H&H"
    if @title.nil?
      base_title
    else
      "#{base_title} | #{@title}"
    end
  end
  
  # Return a delete link only if user is an admin
  def delete_link(target, confirm, title, divider)
    if current_user && current_user.admin?
      @link = divider + link_to("delete", target, :method => :delete, :confirm => confirm, :title => title)
      @link.html_safe
    end
  end
end
