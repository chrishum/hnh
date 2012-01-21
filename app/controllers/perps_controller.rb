class PerpsController < ApplicationController
  
  before_filter :require_user,  :only => [:edit, :update, :destroy]
  before_filter :require_admin, :only => :destroy
  
  def index
    @title = "Perps"
    @perps = Perp.paginate(:page => params[:page])
  end
  
  def show
    @perp = Perp.find(params[:id])
    @statements = @perp.statements.paginate(:page => params[:page], :per_page => 10)
    @title = @perp.full_name
  end
  
  def new
    @perp = Perp.new
    @title = "New Perp"
  end
  
  def create
    @party = Party.find_by_id(params[:party])
    @perp = @party.perps.build(params[:perp])
    if @perp.save
      redirect_to @perp
    else
      @title = "New Perp"
      render 'new'
    end
  end
  
  def edit
    @perp = Perp.find(params[:id])
    @title = "Edit perp"
  end
  
  def update
    @perp = Perp.find(params[:id])
    if params[:party]
      @perp.party = Party.find_by_id(params[:party])
      @perp.save
    end
    if @perp.update_attributes(params[:perp])
      flash[:success] = "Perp updated."
      redirect_to @perp
    else
      @title = "Edit perp"
      render 'edit'
    end
  end
  
  def destroy
    Perp.find(params[:id]).destroy
    flash[:success] = "Perp destroyed."
    redirect_to perps_path
  end
end
