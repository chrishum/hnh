class PerpsController < ApplicationController
  
  def show
    @perp = Perp.find(params[:id])
    @title = @perp.first_name + " " + @perp.last_name
  end
  
  def new
    @perp = Perp.new
    @title = "New Perp"
  end
  
  def create
    @perp = Perp.new(params[:perp])
    if @perp.save
      redirect_to @perp
    else
      @title = "New Perp"
      render 'new'
    end
  end

end
