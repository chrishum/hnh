class PagesController < ApplicationController
  def home
    @title = "Home"
    @statements = Statement.find_top_recent_statements
  end

  def contact
    @title = "Contact"
  end

  def about
    @title = "About"
  end

end
