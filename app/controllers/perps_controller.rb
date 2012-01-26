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
    @parties = Party.all
    @title = "New Perp"
  end
  
  def create
    @party = Party.find_by_id(params[:perp][:party_id])
    @perp = @party.perps.build(params[:perp])
    if @perp.save
      redirect_to @perp
    else
      @parties = Party.all
      @title = "New Perp"
      render 'new'
    end
  end
  
  def edit
    @perp = Perp.find(params[:id])
    @parties = Party.all
    @title = "Edit perp"
  end
  
  def update
    @perp = Perp.find(params[:id])
    @perp.attributes = params[:perp]
    @perp.party_id = params[:perp][:party_id]
    if @perp.save
      flash[:success] = "Perp updated."
      redirect_to @perp
    else
      @parties = Party.all
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
