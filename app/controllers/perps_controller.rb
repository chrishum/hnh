class PerpsController < ApplicationController
  
  before_filter :authenticate, :only => [:edit, :update, :destroy]
  before_filter :admin_user,   :only => :destroy
  
  def index
    @title = "Perps"
    @perps = Perp.paginate(:page => params[:page])
  end
  
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
  
  def edit
    @perp = Perp.find(params[:id])
    @title = "Edit perp"
  end
  
  def update
    @perp = Perp.find(params[:id])
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

private

  def authenticate
    deny_access unless signed_in?
  end
  
  def admin_user
    redirect_to(root_path) unless current_user.admin?
  end
end
